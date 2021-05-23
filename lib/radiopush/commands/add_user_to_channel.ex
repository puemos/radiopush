defmodule Radiopush.Cmd.AddUserToChannel do
  use TypedStruct

  typedstruct module: Cmd do
    field :channel_id, String.t(), enforce: true
    field :user_id, String.t(), enforce: true
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  def run(%Context{} = ctx, %Cmd{} = cmd) do
    owner_id = ctx.user.id

    case Channels.get_channel(cmd.channel_id) do
      {:ok, %{private: true, owner_id: ^owner_id}} -> add_user_to_channel(ctx, cmd)
      {:ok, %{private: true, owner_id: _}} -> {:error, "Unauthorized"}
      {:ok, %{private: false}} -> add_user_to_channel(ctx, cmd)
      {:ok, false} -> {:error, "Unauthorized"}
      {:error, error} -> {:error, error}
    end
  end

  defp add_user_to_channel(%Context{} = _ctx, %Cmd{} = cmd) do
    case Channels.add_user_to_channel(cmd.channel_id, cmd.user_id) do
      {:ok} -> {:ok}
      {:ok, false} -> {:error, "Unauthorized"}
      {:error, error} -> {:error, error}
    end
  end
end
