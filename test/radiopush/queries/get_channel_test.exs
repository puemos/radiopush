defmodule Radiopush.GetChannelTest do
  use Radiopush.DataCase

  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Qry.GetChannel
  alias Radiopush.Context

  describe "get_channel" do
    test "should get a channel by id" do
      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      {:ok, channel} =
        CreateChannel.run(
          %Context{user: creator},
          %CreateChannel.Cmd{name: "some_name"}
        )

      {:ok, channel_check} =
        GetChannel.run(
          %Context{user: creator},
          %GetChannel.Query{
            channel_id: channel.id
          }
        )

      assert channel_check == channel
    end

    test "should get a channel by name" do
      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      {:ok, channel} =
        CreateChannel.run(
          %Context{user: creator},
          %CreateChannel.Cmd{name: "some_name"}
        )

      {:ok, channel_check} =
        GetChannel.run(
          %Context{user: creator},
          %GetChannel.Query{
            name: channel.name
          }
        )

      assert channel_check == channel
    end
  end
end
