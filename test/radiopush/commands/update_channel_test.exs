defmodule Radiopush.Cmd.UpdateChannelTest do
  use ExUnit.Case
  use Radiopush.DataCase

  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.UpdateChannel
  alias Radiopush.Context

  describe "update_channel/2" do
    test "create and update a channel" do
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

      {:ok, updated_channel} =
        UpdateChannel.run(
          %Context{
            user: creator
          },
          %UpdateChannel.Cmd{
            channel_id: channel.id,
            description: "updated description",
            private: true
          }
        )

      assert %{
               description: "updated description",
               private: true
             } = updated_channel
    end

    test "only channel admins can update" do
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
               UpdateChannel.run(
                 %Context{
                   user: guest
                 },
                 %UpdateChannel.Cmd{
                   channel_id: channel.id,
                   description: "updated description",
                   private: true
                 }
               )
    end
  end
end
