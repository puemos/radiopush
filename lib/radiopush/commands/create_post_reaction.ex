defmodule Radiopush.Cmd.CreatePostReaction do
  use TypedStruct

  typedstruct module: Cmd do
    field :post_id, String.t(), enforce: true
    field :emoji, String.t(), enforce: true
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  defp prepare_attrs(%Context{} = ctx, %Cmd{} = cmd) do
    %{
      post_id: cmd.post_id,
      user_id: ctx.user.id,
      emoji: cmd.emoji
    }
  end

  def run(%Context{} = ctx, %Cmd{} = cmd) do
    with {:ok, post} <-
           Channels.get_post(cmd.post_id),
         {:ok, true} <-
           Channels.is_user_in_channel(post.channel_id, ctx.user.id),
         {:ok, _} <-
           Channels.create_post_reaction(prepare_attrs(ctx, cmd)) do
      Channels.get_post(cmd.post_id)
    else
      {:ok, false} -> {:error, "Unauthorized"}
      {:error, error} -> {:error, error}
    end
  end
end
