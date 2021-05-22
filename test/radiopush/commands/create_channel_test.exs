defmodule Radiopush.CreateChannelTest do
  use Radiopush.DataCase
  use ExUnit.Case

  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Context

  describe "create_channel/2" do
    test "create a new channel" do
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

      assert channel.name == "some_name"
      assert channel.description == "some description"
      assert channel.private == false
      assert channel.owner_id == creator.id
    end
  end
end
