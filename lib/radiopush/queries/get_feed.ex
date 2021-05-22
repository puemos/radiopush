defmodule Radiopush.Qry.GetFeed do
  use TypedStruct

  typedstruct module: Query do
    field :inserted_after, DateTime.t()
    field :cursor, String.t()
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  def run(%Context{} = ctx, %Query{cursor: cursor, inserted_after: nil}) do
    with {:ok, posts, metadata} <- Channels.get_feed(ctx.user.id, cursor: cursor) do
      {:ok, posts, metadata}
    else
      {:error, error} ->
        {:error, error}

      {:ok, false} ->
        {:error, "Unauthorized"}
    end
  end

  def run(%Context{} = ctx, %Query{inserted_after: inserted_after}) do
    with {:ok, posts} <- Channels.get_feed_after(ctx.user.id, inserted_after) do
      {:ok, posts}
    else
      {:error, error} ->
        {:error, error}

      {:ok, false} ->
        {:error, "Unauthorized"}
    end
  end
end
