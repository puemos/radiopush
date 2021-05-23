defmodule Radiopush.Channels do
  @moduledoc """
  The Channels context.
  """

  @type permissions :: Radiopush.Channels.Impl.permissions()

  @impl_module Application.get_env(
                 :radiopush,
                 :channels_aggregate_repository,
                 Radiopush.Channels.PostgresImpl
               )

  @behaviour Radiopush.Channels.Impl

  # Channels

  defdelegate create_channel(attrs), to: @impl_module
  defdelegate delete_channel(channel_id), to: @impl_module
  defdelegate update_channel(channel, attrs), to: @impl_module
  defdelegate change_channel(), to: @impl_module
  defdelegate change_channel(channel, attrs), to: @impl_module
  defdelegate get_channel(channel_id), to: @impl_module
  defdelegate get_channel_by_name(name), to: @impl_module
  defdelegate list_public_channels(opts), to: @impl_module

  # Members

  defdelegate is_user_in_channel(channel_id, user_id), to: @impl_module
  defdelegate list_users_by_channel(channel_id, opts), to: @impl_module
  defdelegate list_channels_by_user(user_id, opts), to: @impl_module
  defdelegate add_user_to_channel(channel_id, user_id), to: @impl_module
  defdelegate remove_user_from_channel(channel_id, user_id), to: @impl_module

  # Posts

  defdelegate create_post(attrs), to: @impl_module
  defdelegate delete_post(post_id), to: @impl_module
  defdelegate change_post(post, attrs), to: @impl_module
  defdelegate update_post(post, attrs), to: @impl_module
  defdelegate get_post(post_id), to: @impl_module
  defdelegate list_posts_by_channel(channel_id, opts), to: @impl_module
  defdelegate list_posts_by_channel_after(channel_id, inserted_after), to: @impl_module
  defdelegate get_feed(user_id, opts), to: @impl_module
  defdelegate get_feed_after(user_id, inserted_after), to: @impl_module
  defdelegate list_public_posts(opts), to: @impl_module
  defdelegate list_public_posts_after(inserted_after), to: @impl_module

  # Post reactions

  defdelegate get_post_reaction(post_reaction_id), to: @impl_module
  defdelegate get_post_reaction(user_id, post_id, emoji), to: @impl_module

  defdelegate create_post_reaction(attrs), to: @impl_module
  defdelegate delete_post_reaction(post_reaction_id), to: @impl_module
end
