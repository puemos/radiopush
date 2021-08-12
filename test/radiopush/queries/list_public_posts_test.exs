defmodule Radiopush.ListPublicPostsTest do
  use Radiopush.DataCase
  use ExUnit.Case, async: true
  import Mox
  alias Radiopush.SpotifyExFixtures

  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.CreatePost
  alias Radiopush.Cmd.CreateUser

  alias Radiopush.Qry.ListPublicPosts
  alias Radiopush.Context

  setup :verify_on_exit!

  describe "list_public_posts" do
    test "get only public posts" do
      stub(Radiopush.Spotify.ClientMock, :get_song, fn _, _ ->
        {:ok, SpotifyExFixtures.track()}
      end)

      stub(Radiopush.Spotify.ClientMock, :get_audio_features, fn _, _ ->
        {:ok, SpotifyExFixtures.audio_features()}
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
               ListPublicPosts.run(
                 %Context{user: guest},
                 %ListPublicPosts.Query{}
               )
    end

    test "should get only 20 first posts" do
      stub(Radiopush.Spotify.ClientMock, :get_song, fn _, _ ->
        {:ok, SpotifyExFixtures.track()}
      end)

      stub(Radiopush.Spotify.ClientMock, :get_audio_features, fn _, _ ->
        {:ok, SpotifyExFixtures.audio_features()}
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

      letters_list("a", 60)
      |> Enum.map(
        &CreatePost.run(
          context,
          %CreatePost.Cmd{
            channel_id: channel.id,
            url: "https://open.spotify.com/track/#{&1}"
          }
        )
      )

      {:ok, list, _meta} =
        ListPublicPosts.run(
          context,
          %ListPublicPosts.Query{}
        )

      assert Enum.count(list) == 20
    end

    test "should get next 20 posts" do
      stub(Radiopush.Spotify.ClientMock, :get_song, fn _, _ ->
        {:ok, SpotifyExFixtures.track()}
      end)

      stub(Radiopush.Spotify.ClientMock, :get_audio_features, fn _, _ ->
        {:ok, SpotifyExFixtures.audio_features()}
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

      letters_list("a", 30)
      |> Enum.map(
        &CreatePost.run(
          context,
          %CreatePost.Cmd{
            channel_id: channel.id,
            url: "https://open.spotify.com/track/#{&1}"
          }
        )
      )

      {:ok, list_1, meta} =
        ListPublicPosts.run(
          context,
          %ListPublicPosts.Query{}
        )

      {:ok, list_2, _meta} =
        ListPublicPosts.run(
          context,
          %ListPublicPosts.Query{
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

      stub(Radiopush.Spotify.ClientMock, :get_audio_features, fn _, _ ->
        {:ok, SpotifyExFixtures.audio_features()}
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
        ListPublicPosts.run(
          context,
          %ListPublicPosts.Query{
            inserted_after: dt
          }
        )

      assert Enum.count(list_1) == 1
    end
  end
end
