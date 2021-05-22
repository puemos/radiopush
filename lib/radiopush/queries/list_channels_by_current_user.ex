defmodule Radiopush.Qry.ListChannelsByCurrentUser do
  use TypedStruct

  typedstruct module: Query do
    field :cursor, String.t()
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  def run(%Context{} = ctx, %Query{cursor: cursor}) do
    with {:ok, list, metadata} <-
           Channels.list_channels_by_user(ctx.user.id, cursor: cursor) do
      {:ok, list, metadata}
    else
      {:error, error} ->
        {:error, error}
    end
  end
end
