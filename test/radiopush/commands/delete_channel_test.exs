defmodule Radiopush.DeleteChannelTest do
  use ExUnit.Case
  use Radiopush.DataCase

  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.DeleteChannel
  alias Radiopush.Cmd.CreateUser

  alias Radiopush.Context

  describe "delete_channel/2" do
    test "create and delete a channel" do
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

      assert {:ok} =
               DeleteChannel.run(
                 %Context{
                   user: creator
                 },
                 %DeleteChannel.Cmd{
                   channel_id: channel.id
                 }
               )
    end

    test "only channel admins can delete" do
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

      assert {:error, "Unauthorized"} =
               DeleteChannel.run(
                 %Context{
                   user: guest
                 },
                 %DeleteChannel.Cmd{
                   channel_id: channel.id
                 }
               )
    end
  end
end
