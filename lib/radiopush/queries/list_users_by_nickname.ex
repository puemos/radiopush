defmodule Radiopush.Qry.ListUsersByNickname do
  use TypedStruct

  typedstruct module: Query do
    field :nickname, String.t()
    field :cursor, String.t()
  end

  alias Radiopush.Context
  alias Radiopush.Accounts

  def run(%Context{} = _ctx, %Query{cursor: cursor, nickname: nickname}) do
    case Accounts.list_users_by_nickname(nickname, cursor: cursor) do
      {:ok, users, metadata} ->
        {:ok, users, metadata}

      {:error, error} ->
        {:error, error}

      {:ok, false} ->
        {:error, "Unauthorized"}
    end
  end
end
