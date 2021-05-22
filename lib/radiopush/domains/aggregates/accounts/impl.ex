defmodule Radiopush.Accounts.Impl do
  @moduledoc false

  @type page_metadata :: Radiopush.Infra.page_metadata()
  @type cursor :: Radiopush.Infra.page_cursor()
  @type error :: {:error, String.t()}
  @type ecto_error :: {:error, Ecto.Changeset.t()}

  alias Radiopush.Accounts.{User}

  # Users

  @callback create_user(attrs :: map()) ::
              {:ok, User.t()} | ecto_error()

  @callback delete_user(user_id :: User.id()) ::
              {:ok} | error()

  @callback update_user(user :: User.t(), attrs :: map()) ::
              {:ok, User.t()} | ecto_error()

  @callback get_user(user_id :: User.id()) ::
              {:ok, User.t()} | error()

  @callback get_user_by_email(email :: String.t()) ::
              {:ok, User.t()} | error()

  @callback get_user_by_spotify_id(spotify_id :: String.t()) ::
              {:ok, User.t()} | error()

  @callback list_users(opts :: keyword()) ::
              {:ok, list(User.t()), page_metadata} | error()

  @callback list_users_by_nickname(nickname :: String.t(), opts :: keyword()) ::
              {:ok, list(User.t()), page_metadata} | error()
end
