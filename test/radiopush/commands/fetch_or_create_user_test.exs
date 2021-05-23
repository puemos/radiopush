defmodule Radiopush.FetchOrCreateUserTest do
  use Radiopush.DataCase
  use ExUnit.Case, async: true
  import Mox
  alias Radiopush.SpotifyExFixtures

  alias Radiopush.Cmd.FetchOrCreateUser
  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Qry.ListUsersByChannel
  alias Radiopush.Context

  setup :verify_on_exit!

  describe "create_post/2" do
    test "create a new user" do
      expect(Radiopush.Spotify.ClientMock, :get_profile, fn _ ->
        {:ok, SpotifyExFixtures.profile()}
      end)

      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      {:ok, channel} =
        CreateChannel.run(
          %Context{
            user: creator
          },
          %CreateChannel.Cmd{
            name: "All",
            description: "some description",
            private: false
          }
        )

      {:ok, guest} =
        FetchOrCreateUser.run(
          %Context{},
          %FetchOrCreateUser.Cmd{
            access_token: "a",
            refresh_token: "a"
          }
        )

      {:ok, list, _} =
        ListUsersByChannel.run(
          %Context{
            user: creator
          },
          %ListUsersByChannel.Query{
            channel_id: channel.id
          }
        )

      assert list == [guest, creator]
    end

    test "new user will be added to All" do
      expect(Radiopush.Spotify.ClientMock, :get_profile, fn _ ->
        {:ok, SpotifyExFixtures.profile()}
      end)

      {:ok, creator} =
        FetchOrCreateUser.run(
          %Context{},
          %FetchOrCreateUser.Cmd{
            access_token: "a",
            refresh_token: "a"
          }
        )

      assert creator.nickname == "JM Wizzler"
    end

    test "fetch user" do
      expect(Radiopush.Spotify.ClientMock, :get_profile, fn _ ->
        {:ok, SpotifyExFixtures.profile()}
      end)

      {:ok, _} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "JM Wizzler", spotify_id: "jm", email: "email@example.com"}
        )

      {:ok, creator} =
        FetchOrCreateUser.run(
          %Context{},
          %FetchOrCreateUser.Cmd{
            access_token: "a",
            refresh_token: "a"
          }
        )

      assert creator.nickname == "JM Wizzler"
    end
  end
end
