defmodule Radiopush.Cmd.DeleteOrAddPostReaction do
  use TypedStruct

  typedstruct module: Cmd do
    field :post_id, String.t(), enforce: true
    field :emoji, String.t(), enforce: true
  end

  alias Radiopush.Context
  alias Radiopush.Channels
  alias Radiopush.Cmd.CreatePostReaction

  def run(%Context{} = ctx, %Cmd{} = cmd) do
    case Channels.get_post_reaction(ctx.user.id, cmd.post_id, cmd.emoji) do
      {:ok, post_reaction} ->
        with {:ok, post} <-
               Channels.get_post(post_reaction.post_id),
             {:ok, true} <-
               Channels.is_user_in_channel(post.channel_id, ctx.user.id),
             {:ok} <-
               Channels.delete_post_reaction(post_reaction.id) do
          Channels.get_post(post_reaction.post_id)
        else
          {:ok, false} -> {:error, "Unauthorized"}
          {:error, error} -> {:error, error}
        end

      {:error, "NotFound"} ->
        CreatePostReaction.run(ctx, %CreatePostReaction.Cmd{
          emoji: cmd.emoji,
          post_id: cmd.post_id
        })
    end
  end
end
