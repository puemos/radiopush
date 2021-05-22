defmodule Radiopush.ListChannelsByCurrentUserTest do
  use Radiopush.DataCase

  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Qry.ListChannelsByCurrentUser
  alias Radiopush.Context

  describe "list_channels_by_current_user" do
    test "should get only 50 first channels" do
      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      context = %Context{user: creator}

      letters_list("a", 60)
      |> Enum.map(
        &%CreateChannel.Cmd{
          name: "some_name_#{&1}",
          description: "some description",
          private: false
        }
      )
      |> Enum.map(&CreateChannel.run(context, &1))

      {:ok, list, _} =
        ListChannelsByCurrentUser.run(
          context,
          %ListChannelsByCurrentUser.Query{}
        )

      assert Enum.count(list) == 50
    end

    test "should get next 50 channels" do
      {:ok, creator} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "creator", spotify_id: "creator", email: "creator@u.com"}
        )

      context = %Context{user: creator}

      letters_list("a", 60)
      |> Enum.map(
        &%CreateChannel.Cmd{
          name: "some_name_#{&1}",
          description: "some description",
          private: false
        }
      )
      |> Enum.map(&CreateChannel.run(context, &1))

      {:ok, list_1, meta} =
        ListChannelsByCurrentUser.run(
          context,
          %ListChannelsByCurrentUser.Query{}
        )

      {:ok, list_2, _} =
        ListChannelsByCurrentUser.run(
          context,
          %ListChannelsByCurrentUser.Query{
            cursor: meta.after
          }
        )

      assert Enum.count(list_1) == 50
      assert Enum.count(list_2) == 10
    end
  end
end
