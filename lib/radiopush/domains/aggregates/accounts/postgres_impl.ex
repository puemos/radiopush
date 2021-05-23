defmodule Radiopush.Accounts.PostgresImpl do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Radiopush.Repo

  alias Radiopush.Accounts.{
    User
  }

  alias Radiopush.Infra

  @behaviour Radiopush.Accounts.Impl

  @impl true
  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, "NotFound"}
      user -> {:ok, user}
    end
  end

  @impl true
  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, "NotFound"}
      user -> {:ok, user}
    end
  end

  @impl true
  def get_user_by_spotify_id(spotify_id) do
    case Repo.get_by(User, spotify_id: spotify_id) do
      nil -> {:error, "NotFound"}
      user -> {:ok, user}
    end
  end

  @impl true
  def create_user(attrs) do
    %User{}
    |> change_user(attrs)
    |> Repo.insert()
  end

  defp change_user(%User{} = user, attrs) do
    User.changeset(user, attrs)
  end

  @impl true
  def update_user(%User{} = user, attrs) do
    user
    |> change_user(attrs)
    |> Repo.update()
  end

  @impl true
  def delete_user(user_id)
      when is_binary(user_id) do
    query =
      from u in User,
        where: u.id == ^user_id

    case Repo.delete_all(query) do
      nil ->
        {:error, "NotFound"}

      {0, _} ->
        {:error, "NotFound"}

      {1, _} ->
        {:ok}
    end
  end

  defp list_users_query do
    from u in User,
      order_by: [asc: u.nickname]
  end

  @impl true
  def list_users(opts) do
    cursor = Keyword.get(opts, :cursor, nil)
    query = list_users_query()

    %{entries: entries, metadata: metadata} =
      Repo.paginate(
        query,
        after: cursor,
        sort_direction: :asc,
        cursor_fields: [:nickname],
        limit: 100
      )

    metadata = Infra.PageMetadata.new(metadata)

    {:ok, entries, metadata}
  end

  defp list_users_by_nickname_query(nickname) do
    like_exp = "%#{nickname}%"

    from u in User,
      where: ilike(u.nickname, ^like_exp),
      order_by: [asc: u.nickname]
  end

  @impl true
  def list_users_by_nickname(nickname, opts) do
    cursor = Keyword.get(opts, :cursor, nil)
    query = list_users_by_nickname_query(nickname)

    %{entries: entries, metadata: metadata} =
      Repo.paginate(
        query,
        after: cursor,
        sort_direction: :asc,
        cursor_fields: [:nickname],
        limit: 50
      )

    metadata = Infra.PageMetadata.new(metadata)

    {:ok, entries, metadata}
  end
end
