defmodule Radiopush.CreatePostTest do
  use Radiopush.DataCase
  use ExUnit.Case, async: true
  import Mox
  alias Radiopush.SpotifyExFixtures

  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.CreatePost
  alias Radiopush.Context

  setup :verify_on_exit!

  describe "create_post/2" do
    test "create a new channel and post" do
      expect(Radiopush.Spotify.ClientMock, :get_song, fn _, _ ->
        {:ok, SpotifyExFixtures.track()}
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
            name: "some_name",
            description: "some description",
            private: false
          }
        )

      {:ok, post} =
        CreatePost.run(
          Context.new(%{
            user: creator,
            credentials: %{access_token: "asd", refresh_token: "asd"}
          }),
          %CreatePost.Cmd{
            channel_id: channel.id,
            url: "https://open.spotify.com/track/39p88iz6Hzx5KN00QbLIdv"
          }
        )

      assert post.album == "Blood Sugar Sex Magik (Deluxe Edition)"
    end
  end
end
