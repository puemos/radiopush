defmodule Radiopush.Qry.ListPublicChannels do
  use TypedStruct

  typedstruct module: Query do
    field :cursor, String.t()
    field :name, String.t()
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  def run(%Context{} = ctx, %Query{cursor: cursor, name: name}) do
    with {:ok, list, metadata} <-
           Channels.list_public_channels(cursor: cursor, name: name),
         {:ok, joined} <-
           Channels.is_user_in_channel(
             Enum.map(list, &Map.get(&1, :id)),
             ctx.user.id
           ) do
      list =
        Enum.map(list, fn channel ->
          Map.put(channel, :joined, Enum.member?(joined, channel.id))
        end)

      {:ok, list, metadata}
    else
      {:error, error} ->
        {:error, error}
    end
  end
end
