defmodule Radiopush.Qry.ListPublicPosts do
  use TypedStruct

  typedstruct module: Query do
    field :inserted_after, DateTime.t()
    field :cursor, String.t()
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  # All public

  def run(%Context{} = _ctx, %Query{cursor: cursor, inserted_after: nil}) do
    with {:ok, posts, metadata} <-
           Channels.list_public_posts(cursor: cursor) do
      {:ok, posts, metadata}
    else
      {:error, error} ->
        {:error, error}
    end
  end

  def run(%Context{} = _ctx, %Query{inserted_after: inserted_after}) do
    with {:ok, posts} <-
           Channels.list_public_posts_after(inserted_after) do
      {:ok, posts}
    else
      {:error, error} ->
        {:error, error}
    end
  end
end
