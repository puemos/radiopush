defmodule Radiopush.Qry.GetChannel do
  use TypedStruct

  typedstruct module: Query do
    field :channel_id, String.t()
    field :name, String.t()
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  def run(%Context{} = ctx, %Query{channel_id: channel_id, name: nil}) do
    with {:ok, true} <-
           Channels.is_user_in_channel(channel_id, ctx.user.id),
         {:ok, channel} <- Channels.get_channel(channel_id) do
      {:ok, channel}
    else
      {:error, error} ->
        {:error, error}

      {:ok, false} ->
        {:error, "Unauthorized"}
    end
  end

  def run(%Context{} = ctx, %Query{name: name}) do
    with {:ok, channel} <- Channels.get_channel_by_name(name),
         {:ok, true} <-
           Channels.is_user_in_channel(channel.id, ctx.user.id) do
      {:ok, channel}
    else
      {:error, error} ->
        {:error, error}

      {:ok, false} ->
        {:error, "Unauthorized"}
    end
  end
end
