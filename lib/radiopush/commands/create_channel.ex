defmodule Radiopush.Cmd.CreateChannel do
  use TypedStruct

  typedstruct module: Cmd do
    field :name, String.t(), enforce: true
    field :description, String.t()
    field :private, boolean(), default: true
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  defp prepare_params(%Context{} = ctx, %Cmd{} = cmd) do
    cmd
    |> Map.from_struct()
    |> Map.merge(%{owner_id: ctx.user.id})
  end

  def run(%Context{} = ctx, %Cmd{} = cmd) do
    with {:ok, channel} <-
           Channels.create_channel(prepare_params(ctx, cmd)),
         {:ok} <- Channels.add_user_to_channel(channel.id, ctx.user.id) do
      {:ok, channel}
    else
      {:error, error} -> {:error, error}
    end
  end
end
