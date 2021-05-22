defmodule Radiopush.Cmd.CreatePost do
  use TypedStruct

  typedstruct module: Cmd do
    field :channel_id, String.t(), enforce: true
    field :url, String.t(), enforce: true
  end

  alias Radiopush.Context
  alias Radiopush.Channels
  alias Radiopush.Spotify

  def prepare_post_attrs(user_id, channel_id, details) do
    Map.from_struct(details)
    |> Map.merge(%{user_id: user_id})
    |> Map.merge(%{channel_id: channel_id})
  end

  def run(%Context{} = ctx, %Cmd{} = cmd) do
    with {:ok, true} <-
           Channels.is_user_in_channel(cmd.channel_id, ctx.user.id),
         {:ok, details} <-
           Spotify.get_details_from_url(ctx.credentials, cmd.url),
         {:ok, post} <-
           Channels.create_post(prepare_post_attrs(ctx.user.id, cmd.channel_id, details)) do
      {:ok, post}
    else
      {:ok, false} -> {:error, "Unauthorized"}
      {:error, error} -> {:error, error}
    end
  end
end
