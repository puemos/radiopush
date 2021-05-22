defmodule Radiopush.AddUserToChannelTest do
  use ExUnit.Case
  use Radiopush.DataCase

  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.AddUserToChannel
  alias Radiopush.Qry.ListUsersByChannel
  alias Radiopush.Context

  describe "add_user_to_channel/2" do
    test "create a new channel and add a user" do
      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      {:ok, member} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "member", spotify_id: "member", email: "member@u.com"}
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

      assert {:ok} ==
               AddUserToChannel.run(
                 %Context{
                   user: creator
                 },
                 %AddUserToChannel.Cmd{
                   channel_id: channel.id,
                   user_id: member.id
                 }
               )

      {:ok, users, _} =
        ListUsersByChannel.run(
          %Context{
            user: creator
          },
          %ListUsersByChannel.Query{
            channel_id: channel.id
          }
        )

      assert Enum.find(users, fn u -> u.id == member.id end)
    end

    test "only private channel's admins can add users" do
      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      {:ok, member} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "member", spotify_id: "member", email: "member@u.com"}
        )

      {:ok, guest} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "guest", spotify_id: "guest", email: "guest@u.com"}
        )

      {:ok, channel} =
        CreateChannel.run(
          %Context{user: creator},
          %CreateChannel.Cmd{name: "some_name", private: true}
        )

      assert {:error, "Unauthorized"} =
               AddUserToChannel.run(
                 %Context{
                   user: guest
                 },
                 %AddUserToChannel.Cmd{
                   channel_id: channel.id,
                   user_id: member.id
                 }
               )
    end

    test "anyone can add users to public channel" do
      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      {:ok, member} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "member", spotify_id: "member", email: "member@u.com"}
        )

      {:ok, guest} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "guest", spotify_id: "guest", email: "guest@u.com"}
        )

      {:ok, channel} =
        CreateChannel.run(
          %Context{user: creator},
          %CreateChannel.Cmd{name: "some_name", private: false}
        )

      {:ok} =
        AddUserToChannel.run(
          %Context{
            user: guest
          },
          %AddUserToChannel.Cmd{
            channel_id: channel.id,
            user_id: member.id
          }
        )

      {:ok, users, _} =
        ListUsersByChannel.run(
          %Context{
            user: creator
          },
          %ListUsersByChannel.Query{
            channel_id: channel.id
          }
        )

      assert Enum.find(users, fn u -> u.id == member.id end)
    end
  end
end
