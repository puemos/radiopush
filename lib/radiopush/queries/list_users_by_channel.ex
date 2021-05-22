defmodule Radiopush.Qry.ListUsersByChannel do
  use TypedStruct

  typedstruct module: Query do
    field :channel_id, String.t(), enforce: true
    field :cursor, String.t()
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  def run(%Context{} = ctx, %Query{channel_id: channel_id, cursor: cursor}) do
    with {:ok, true} <-
           Channels.is_user_in_channel(channel_id, ctx.user.id),
         {:ok, users, metadata} <-
           Channels.list_users_by_channel(channel_id, cursor: cursor) do
      {:ok, users, metadata}
    else
      {:error, error} ->
        {:error, error}

      {:ok, false} ->
        {:error, "Unauthorized"}
    end
  end
end
