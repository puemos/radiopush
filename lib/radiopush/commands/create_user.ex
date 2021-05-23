defmodule Radiopush.Cmd.CreateUser do
  use TypedStruct

  typedstruct module: Cmd do
    field :nickname, String.t(), enforce: true
    field :email, String.t(), enforce: true
    field :spotify_id, String.t(), enforce: true
  end

  alias Radiopush.Context
  alias Radiopush.Accounts

  def run(%Context{} = _ctx, %Cmd{} = cmd) do
    case Accounts.create_user(Map.from_struct(cmd)) do
      {:ok, user} -> {:ok, user}
      {:error, error} -> {:error, error}
    end
  end
end
