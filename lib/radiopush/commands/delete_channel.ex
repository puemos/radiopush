defmodule Radiopush.Cmd.DeleteChannel do
  use TypedStruct

  typedstruct module: Cmd do
    field :channel_id, String.t(), enforce: true
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  def run(%Context{} = ctx, %Cmd{} = cmd) do
    owner_id = ctx.user.id

    with {:ok, %{owner_id: ^owner_id}} <-
           Channels.get_channel(cmd.channel_id),
         {:ok} <-
           Channels.delete_channel(cmd.channel_id) do
      {:ok}
    else
      {:ok, false} -> {:error, "Unauthorized"}
      {:ok, %{owner_id: _}} -> {:error, "Unauthorized"}
      {:error, error} -> {:error, error}
    end
  end
end
