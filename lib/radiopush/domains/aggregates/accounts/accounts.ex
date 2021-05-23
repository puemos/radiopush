defmodule Radiopush.Accounts do
  @moduledoc """
  The Accounts context.
  """

  @impl_module Application.compile_env(
                 :radiopush,
                 :accounts_aggregate_repository,
                 Radiopush.Accounts.PostgresImpl
               )

  @behaviour Radiopush.Accounts.Impl

  # Users

  defdelegate create_user(attrs), to: @impl_module
  defdelegate delete_user(user_id), to: @impl_module
  defdelegate update_user(user, attrs), to: @impl_module
  defdelegate get_user(user_id), to: @impl_module
  defdelegate get_user_by_email(email), to: @impl_module
  defdelegate get_user_by_spotify_id(spotify_id), to: @impl_module
  defdelegate list_users(opts), to: @impl_module
  defdelegate list_users_by_nickname(name, opts), to: @impl_module
end
