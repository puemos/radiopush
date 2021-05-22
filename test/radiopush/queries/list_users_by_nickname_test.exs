defmodule Radiopush.ListUsersByNicknameTest do
  use ExUnit.Case
  use Radiopush.DataCase

  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Qry.ListUsersByNickname
  alias Radiopush.Context

  describe "list_users_by_nickname" do
    test "should get only users with fuzzy match" do
      {:ok, _} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "Moonshot", spotify_id: "moonshot", email: "moonshot@u.com"}
        )

      {:ok, _} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "blue moon", spotify_id: "bluemoo", email: "blue_moon@u.com"}
        )

      {:ok, _} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "foon", spotify_id: "foon", email: "foon@u.com"}
        )

      {:ok, list, _meta} =
        ListUsersByNickname.run(
          %Context{},
          %ListUsersByNickname.Query{
            nickname: "moon"
          }
        )

      assert [%{nickname: "blue moon"}, %{nickname: "Moonshot"}] = list
    end

    test "should get only 50 first users" do
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

      {:ok, list, _meta} =
        ListUsersByNickname.run(
          %Context{},
          %ListUsersByNickname.Query{
            nickname: "member"
          }
        )

      assert Enum.count(list) == 50
    end

    test "should get next 50 users" do
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

      {:ok, list_1, meta} =
        ListUsersByNickname.run(
          %Context{},
          %ListUsersByNickname.Query{
            nickname: "member"
          }
        )

      {:ok, list_2, _meta} =
        ListUsersByNickname.run(
          %Context{},
          %ListUsersByNickname.Query{
            nickname: "member",
            cursor: meta.after
          }
        )

      assert Enum.count(list_1) == 50
      assert Enum.count(list_2) == 10
    end
  end
end
