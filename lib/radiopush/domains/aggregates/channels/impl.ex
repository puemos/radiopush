defmodule Radiopush.Channels.Impl do
  @moduledoc false

  @type page_metadata :: Radiopush.Infra.page_metadata()
  @type cursor :: Radiopush.Infra.page_cursor()
  @type error :: {:error, String.t()}
  @type ecto_error :: {:error, Ecto.Changeset.t()}
  @type action :: :read | :update | :delete | :post

  alias Radiopush.Channels.{
    Channel,
    Post,
    PostReaction
  }

  alias Radiopush.Accounts.{
    User
  }

  # Channels

  @callback create_channel(attrs :: map()) ::
              {:ok, Channel.t()} | ecto_error()

  @callback delete_channel(channel_id :: Channel.id()) ::
              {:ok} | error()

  @callback update_channel(channel :: Channel.t(), attrs :: map()) ::
              {:ok, Channel.t()} | ecto_error()

  @callback change_channel(channel :: Channel.t(), attrs :: map()) ::
              Ecto.Changeset.t()

  @callback change_channel() ::
              Ecto.Changeset.t()

  @callback get_channel(channel_id :: Channel.id()) ::
              {:ok, Channel.t()} | error()

  @callback get_channel_by_name(name :: String.t()) ::
              {:ok, Channel.t()} | error()

  @callback list_public_channels(opts :: keyword()) ::
              {:ok, list(Channel.t()), page_metadata} | error()

  # Members

  @callback is_user_in_channel(channel_id :: Channel.id(), user_id :: User.t()) ::
              {:ok, boolean()} | error()

  @callback list_users_by_channel(channel_id :: Channel.id(), opts :: keyword()) ::
              {:ok, list(User.t()), page_metadata} | error()

  @callback list_channels_by_user(user_id :: User.t(), opts :: keyword()) ::
              {:ok, list(Channel.t()), page_metadata} | error()

  @callback add_user_to_channel(channel_id :: Channel.id(), user_id :: User.t()) ::
              {:ok, Channel.t()} | error()

  @callback remove_user_from_channel(channel_id :: Channel.id(), user_id :: User.t()) ::
              {:ok} | error()

  # Posts

  @callback create_post(attrs :: map()) ::
              {:ok, Post.t()} | ecto_error()

  @callback delete_post(post_id :: Post.id()) ::
              {:ok} | error()

  @callback change_post(attrs :: Post.t(), attrs :: map()) ::
              Ecto.Changeset.t()

  @callback update_post(attrs :: Post.t(), attrs :: map()) ::
              {:ok, Post.t()} | ecto_error()

  @callback get_post(post_id :: Post.id()) ::
              {:ok, Post.t()} | error()

  @callback list_posts_by_channel(channel_id :: Channel.id(), opts :: keyword()) ::
              {:ok, list(Post.t()), page_metadata} | error()

  @callback list_posts_by_channel_after(
              channel_id :: Channel.id(),
              inserted_after :: DateTime.t()
            ) ::
              {:ok, list(Post.t())} | error()

  @callback get_feed(user_id :: User.id(), opts :: keyword()) ::
              {:ok, list(Post.t()), page_metadata} | error()

  @callback get_feed_after(
              user_id :: User.id(),
              inserted_after :: DateTime.t()
            ) ::
              {:ok, list(Post.t())} | error()

  @callback list_public_posts(opts :: keyword()) ::
              {:ok, list(Post.t()), page_metadata} | error()

  @callback list_public_posts_after(inserted_after :: DateTime.t()) ::
              {:ok, list(Post.t())} | error()

  # Post reactions

  @callback get_post_reaction(post_reaction_id :: PostReaction.id()) ::
              {:ok} | error()

  @callback get_post_reaction(user_id :: User.t(), post_id :: String.t(), emoji :: String.t()) ::
              {:ok} | error()

  @callback create_post_reaction(attrs :: map()) ::
              {:ok, PostReaction.t()} | ecto_error()

  @callback delete_post_reaction(post_reaction_id :: PostReaction.id()) ::
              {:ok} | error()
end
