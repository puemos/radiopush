defmodule Radiopush.Qry.ListPostsByChannel do
  defmodule Query do
    use TypedStruct

    typedstruct do
      field :channel_id, String.t(), enforce: true
      field :inserted_after, DateTime.t()
      field :cursor, String.t()
    end
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  def run(%Context{} = ctx, %Query{channel_id: channel_id, cursor: cursor, inserted_after: nil}) do
    with {:ok, true} <-
           Channels.is_user_in_channel(channel_id, ctx.user.id),
         {:ok, posts, metadata} <-
           Channels.list_posts_by_channel(channel_id, cursor: cursor) do
      {:ok, posts, metadata}
    else
      {:error, error} ->
        {:error, error}

      {:ok, false} ->
        {:error, "Unauthorized"}
    end
  end

  def run(%Context{} = ctx, %Query{channel_id: channel_id, inserted_after: inserted_after}) do
    with {:ok, true} <-
           Channels.is_user_in_channel(channel_id, ctx.user.id),
         {:ok, posts} <-
           Channels.list_posts_by_channel_after(channel_id, inserted_after) do
      {:ok, posts}
    else
      {:error, error} ->
        {:error, error}

      {:ok, false} ->
        {:error, "Unauthorized"}
    end
  end
end
