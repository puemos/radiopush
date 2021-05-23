defmodule Radiopush.Qry.ListPublicChannelsTest do
  use ExUnit.Case
  use Radiopush.DataCase

  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Qry.ListPublicChannels
  alias Radiopush.Context

  describe "list_channels_by_current_user" do
    test "should get only public channels" do
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

      letters_list("a", 60)
      |> Enum.map(fn letter ->
        %CreateChannel.Cmd{
          name: "some_name_#{letter}",
          description: "some description",
          private: true
        }
      end)
      |> Enum.map(
        &CreateChannel.run(
          %Context{user: creator},
          &1
        )
      )

      {:ok, list, _} =
        ListPublicChannels.run(
          %Context{user: guest},
          %ListPublicChannels.Query{}
        )

      assert list == []
    end

    test "should get only 50 first channels" do
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

      letters_list("a", 2)
      |> Enum.map(fn letter ->
        %CreateChannel.Cmd{
          name: "some_name_#{letter}",
          description: "some description",
          private: false
        }
      end)
      |> Enum.map(
        &CreateChannel.run(
          %Context{user: creator},
          &1
        )
      )

      letters_list("a", 50)
      |> Enum.map(fn letter ->
        %CreateChannel.Cmd{
          name: "2some_name_#{letter}",
          description: "some description",
          private: false
        }
      end)
      |> Enum.map(
        &CreateChannel.run(
          %Context{user: guest},
          &1
        )
      )

      {:ok, list, _} =
        ListPublicChannels.run(
          %Context{user: guest},
          %ListPublicChannels.Query{}
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
        ListPublicChannels.run(
          context,
          %ListPublicChannels.Query{}
        )

      {:ok, list_2, _} =
        ListPublicChannels.run(
          context,
          %ListPublicChannels.Query{
            cursor: meta.after
          }
        )

      assert Enum.count(list_1) == 50
      assert Enum.count(list_2) == 10
    end
  end
end
