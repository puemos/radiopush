defmodule Radiopush.DeleteOrAddPostReactionTest do
  use Radiopush.DataCase
  use ExUnit.Case, async: true
  import Mox
  alias Radiopush.SpotifyExFixtures

  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.CreatePost
  alias Radiopush.Cmd.CreatePostReaction
  alias Radiopush.Cmd.DeleteOrAddPostReaction
  alias Radiopush.Qry.ListPostsByChannel
  alias Radiopush.Context

  setup :verify_on_exit!

  describe "delete_post_reaction/2" do
    test "create a new channel, post, add reaction and delete it" do
      expect(Radiopush.Spotify.ClientMock, :get_song, fn _, _ ->
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
            description: "some description",
            private: false
          }
        )

      {:ok, post} =
        CreatePost.run(
          context,
          %CreatePost.Cmd{
            channel_id: channel.id,
            url: "https://open.spotify.com/track/39p88iz6Hzx5KN00QbLIdv"
          }
        )

      {:ok, post} =
        CreatePostReaction.run(
          context,
          %CreatePostReaction.Cmd{
            emoji: "smile",
            post_id: post.id
          }
        )

      {:ok, _post} =
        DeleteOrAddPostReaction.run(
          context,
          %DeleteOrAddPostReaction.Cmd{
            post_id: post.id,
            emoji: "smile"
          }
        )

      {:ok, list, _} =
        ListPostsByChannel.run(
          context,
          %ListPostsByChannel.Query{
            channel_id: channel.id
          }
        )

      assert Enum.at(list, 0).reactions == []
    end
  end
end
