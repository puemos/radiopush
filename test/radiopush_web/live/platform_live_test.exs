defmodule RadiopushWeb.PlatformLiveTest do
  use RadiopushWeb.ConnCase

  import Mox

  alias Radiopush.Cmd.{CreateChannel, FetchOrCreateUser}
  alias Radiopush.Context
  alias Radiopush.SpotifyExFixtures

  setup :verify_on_exit!

  describe "guest access" do
    test "landing page renders", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "Continue with Spotify"
      assert html =~ "Radiopush"
    end

    test "guest is redirected from /home to /", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/"}}} = live(conn, "/home")
    end
  end

  describe "authenticated access" do
    test "authenticated user is redirected from / to /home", %{conn: conn} do
      conn = authenticated_conn(conn)

      assert {:error, {:redirect, %{to: "/home"}}} = live(conn, "/")
    end

    test "authenticated user can open /home", %{conn: conn} do
      conn = authenticated_conn(conn)

      {:ok, _view, html} = live(conn, "/home")

      assert html =~ "Home"
      assert html =~ "Latest posts from all your channels"
    end

    test "authenticated user can open an existing channel page", %{conn: conn} do
      conn =
        authenticated_conn(conn, %{
          id: "platform-owner",
          email: "platform-owner@example.com",
          display_name: "Platform Owner"
        })

      {:ok, user} = fetch_or_create_user()
      channel_name = "platform_#{System.unique_integer([:positive])}"

      {:ok, channel} =
        CreateChannel.run(
          %Context{user: user},
          %CreateChannel.Cmd{
            name: channel_name,
            description: "Platform test channel",
            private: false
          }
        )

      {:ok, _view, html} = live(conn, "/c/#{channel.name}")

      assert html =~ channel.name
    end
  end

  defp authenticated_conn(conn, profile_overrides \\ %{}) do
    profile =
      SpotifyExFixtures.profile()
      |> Map.merge(profile_overrides)

    stub(Radiopush.Spotify.ClientMock, :get_profile, fn _ ->
      {:ok, profile}
    end)

    init_test_session(conn, spotify_credentials: spotify_credentials())
  end

  defp fetch_or_create_user do
    FetchOrCreateUser.run(
      %Context{},
      %FetchOrCreateUser.Cmd{
        access_token: spotify_credentials().access_token,
        refresh_token: spotify_credentials().refresh_token
      }
    )
  end

  defp spotify_credentials do
    %{
      access_token: "test-access-token",
      refresh_token: "test-refresh-token"
    }
  end
end
