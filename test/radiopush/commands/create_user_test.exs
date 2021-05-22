defmodule Radiopush.CreateUserTest do
  use ExUnit.Case
  use Radiopush.DataCase

  alias Radiopush.Cmd.CreateUser
  alias Radiopush.Context

  describe "create_user/2" do
    test "create a new user" do
      {:ok, user} =
        CreateUser.run(
          %Context{},
          %CreateUser.Cmd{nickname: "test", spotify_id: "test", email: "u@u.com"}
        )

      assert user.nickname == "test"
      assert user.email == "u@u.com"
    end
  end
end
