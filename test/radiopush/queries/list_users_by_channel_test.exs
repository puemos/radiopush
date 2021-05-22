defmodule Radiopush.ListUsersByChannelTest do
  use Radiopush.DataCase

  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Cmd.AddUserToChannel
  alias Radiopush.Qry.ListUsersByChannel
  alias Radiopush.Context

  describe "list_users_by_channel" do
    test "only channel members can view list of its users" do
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
               ListUsersByChannel.run(
                 %Context{user: guest},
                 %ListUsersByChannel.Query{
                   channel_id: channel.id
                 }
               )
    end

    test "should get only 50 first users" do
      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      context = %Context{user: creator}

      {:ok, channel} =
        CreateChannel.run(
          context,
          %CreateChannel.Cmd{name: "some_name"}
        )

      letters_list("a", 60)
      |> Enum.map(
        &CreateUser.run(
          %Context{},
          %CreateUser.Cmd{
            nickname: "member #{&1}",
            spotify_id: "member_#{&1}",
            email: "member_#{&1}@u.com"
          }
        )
      )
      |> Enum.map(fn {:ok, user} ->
        AddUserToChannel.run(
          context,
          %AddUserToChannel.Cmd{
            channel_id: channel.id,
            user_id: user.id
          }
        )
      end)

      {:ok, list, _meta} =
        ListUsersByChannel.run(
          context,
          %ListUsersByChannel.Query{
            channel_id: channel.id
          }
        )

      assert Enum.count(list) == 50
    end

    test "should get next 50 users" do
      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      context = %Context{user: creator}

      {:ok, channel} =
        CreateChannel.run(
          context,
          %CreateChannel.Cmd{
            name: "some_name"
          }
        )

      letters_list("a", 60)
      |> Enum.map(
        &CreateUser.run(
          %Context{},
          %CreateUser.Cmd{
            nickname: "member #{&1}",
            spotify_id: "member_#{&1}",
            email: "member_#{&1}@u.com"
          }
        )
      )
      |> Enum.map(fn {:ok, user} ->
        AddUserToChannel.run(
          context,
          %AddUserToChannel.Cmd{
            channel_id: channel.id,
            user_id: user.id
          }
        )
      end)

      {:ok, list_1, meta} =
        ListUsersByChannel.run(
          context,
          %ListUsersByChannel.Query{
            channel_id: channel.id
          }
        )

      {:ok, list_2, _meta} =
        ListUsersByChannel.run(
          context,
          %ListUsersByChannel.Query{
            channel_id: channel.id,
            cursor: meta.after
          }
        )

      assert Enum.count(list_1) == 50
      assert Enum.count(list_2) == 11
    end
  end
end
