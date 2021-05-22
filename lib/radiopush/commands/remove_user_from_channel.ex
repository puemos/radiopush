defmodule Radiopush.Cmd.RemoveUserFromChannel do
  use TypedStruct

  typedstruct module: Cmd do
    field :channel_id, String.t(), enforce: true
    field :user_id, String.t(), enforce: true
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  def run(%Context{} = ctx, %Cmd{} = cmd) do
    case ctx.user.id == cmd.user_id do
      true -> users_remove_themselves(ctx, cmd)
      false -> manager_remove_user(ctx, cmd)
    end
  end

  defp manager_remove_user(%Context{} = ctx, %Cmd{} = cmd) do
    owner_id = ctx.user.id

    with {:ok, %{owner_id: ^owner_id}} <-
           Channels.get_channel(cmd.channel_id),
         {:ok} <- Channels.remove_user_from_channel(cmd.channel_id, cmd.user_id) do
      {:ok}
    else
      {:ok, false} -> {:error, "Unauthorized"}
      {:ok, %{owner_id: _}} -> {:error, "Unauthorized"}
      {:error, error} -> {:error, error}
    end
  end

  defp users_remove_themselves(%Context{} = _ctx, %Cmd{} = cmd) do
    with {:ok, true} <- Channels.is_user_in_channel(cmd.channel_id, cmd.user_id),
         {:ok} <- Channels.remove_user_from_channel(cmd.channel_id, cmd.user_id) do
      {:ok}
    else
      {:ok, false} -> {:error, "Unauthorized"}
      {:error, error} -> {:error, error}
    end
  end
end
