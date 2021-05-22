defmodule Radiopush.GetFeedTest do
  use Radiopush.DataCase
  use ExUnit.Case, async: true
  import Mox
  alias Radiopush.SpotifyExFixtures

  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.CreatePost
  alias Radiopush.Cmd.CreateUser

  alias Radiopush.Qry.GetFeed
  alias Radiopush.Context

  setup :verify_on_exit!

  describe "list_public_posts" do
    test "get only public posts" do
      stub(Radiopush.Spotify.ClientMock, :get_song, fn _, _ ->
        {:ok, SpotifyExFixtures.track()}
      end)

      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      {:ok, guest} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "guest", spotify_id: "guest", email: "guest@u.com"}
        )

      {:ok, channel} =
        CreateChannel.run(
          %Context{user: creator},
          %CreateChannel.Cmd{name: "some_name"}
        )

      CreatePost.run(
        Context.new(%{
          user: creator,
          credentials: %{access_token: "asd", refresh_token: "asd"}
        }),
        %CreatePost.Cmd{
          channel_id: channel.id,
          url: "https://open.spotify.com/track/a"
        }
      )

      assert {:ok, [], _} =
               GetFeed.run(
                 %Context{user: guest},
                 %GetFeed.Query{}
               )
    end

    test "should get only 20 first posts" do
      stub(Radiopush.Spotify.ClientMock, :get_song, fn _, _ ->
        {:ok, SpotifyExFixtures.track()}
      end)

      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      context =
        Context.new(%{
          user: creator,
          credentials: %{access_token: "asd", refresh_token: "asd"}
        })

      {:ok, channel} =
        CreateChannel.run(
          context,
          %CreateChannel.Cmd{name: "some_name", private: false}
        )

      {:ok, channel_2} =
        CreateChannel.run(
          context,
          %CreateChannel.Cmd{name: "some_name_2", private: false}
        )

      letters_list("a", 60)
      |> Enum.map(fn letter ->
        CreatePost.run(
          context,
          %CreatePost.Cmd{
            channel_id: channel.id,
            url: "https://open.spotify.com/track/#{letter}"
          }
        )

        CreatePost.run(
          context,
          %CreatePost.Cmd{
            channel_id: channel_2.id,
            url: "https://open.spotify.com/track/#{letter}"
          }
        )
      end)

      {:ok, list, _meta} =
        GetFeed.run(
          context,
          %GetFeed.Query{}
        )

      assert Enum.count(list) == 20
    end

    test "should get next 20 posts" do
      stub(Radiopush.Spotify.ClientMock, :get_song, fn _, _ ->
        {:ok, SpotifyExFixtures.track()}
      end)

      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      context =
        Context.new(%{
          user: creator,
          credentials: %{access_token: "asd", refresh_token: "asd"}
        })

      {:ok, channel} =
        CreateChannel.run(
          context,
          %CreateChannel.Cmd{name: "some_name", private: false}
        )

      {:ok, channel_2} =
        CreateChannel.run(
          context,
          %CreateChannel.Cmd{name: "some_name_2", private: false}
        )

      letters_list("a", 15)
      |> Enum.map(fn letter ->
        CreatePost.run(
          context,
          %CreatePost.Cmd{
            channel_id: channel.id,
            url: "https://open.spotify.com/track/#{letter}"
          }
        )

        CreatePost.run(
          context,
          %CreatePost.Cmd{
            channel_id: channel_2.id,
            url: "https://open.spotify.com/track/#{letter}"
          }
        )
      end)

      {:ok, list_1, meta} =
        GetFeed.run(
          context,
          %GetFeed.Query{}
        )

      {:ok, list_2, _meta} =
        GetFeed.run(
          context,
          %GetFeed.Query{
            cursor: meta.after
          }
        )

      assert Enum.count(list_1) == 20
      assert Enum.count(list_2) == 10
    end

    test "should get only posts created after" do
      stub(Radiopush.Spotify.ClientMock, :get_song, fn _, _ ->
        {:ok, SpotifyExFixtures.track()}
      end)

      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      context =
        Context.new(%{
          user: creator,
          credentials: %{access_token: "asd", refresh_token: "asd"}
        })

      {:ok, channel} =
        CreateChannel.run(
          context,
          %CreateChannel.Cmd{
            name: "some_name",
            private: false
          }
        )

      CreatePost.run(
        context,
        %CreatePost.Cmd{
          channel_id: channel.id,
          url: "https://open.spotify.com/track/a"
        }
      )

      dt = DateTime.utc_now()

      CreatePost.run(
        context,
        %CreatePost.Cmd{
          channel_id: channel.id,
          url: "https://open.spotify.com/track/a"
        }
      )

      {:ok, list_1} =
        GetFeed.run(
          context,
          %GetFeed.Query{
            inserted_after: dt
          }
        )

      assert Enum.count(list_1) == 1
    end
  end
end
