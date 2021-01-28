defmodule Radiopush.Channels do
  @moduledoc """
  The Channels context.
  """

  import Ecto.Query, warn: false
  alias Radiopush.Repo

  alias Radiopush.Channels.{Channel, Member, Post}
  alias Radiopush.Accounts
  alias Radiopush.Accounts.{User}

  @doc """
  Returns the list of channels.

  ## Examples

      iex> list_channels()
      [%Channel{}, ...]

  """
  def list_channels do
    Repo.all(Channel)
  end

  @doc """
  Returns the list of channels for a user.

  ## Examples

      iex> list_channels_by_user(%User{})
      [%Channel{}, ...]

  """
  def list_channels_by_user(user) do
    user
    |> Repo.preload(:channels)
    |> Map.get(:channels)
  end

  @doc """
  Gets a single channel.

  Raises `Ecto.NoResultsError` if the Channel does not exist.

  ## Examples

      iex> get_channel!(123)
      %Channel{}

      iex> get_channel!(456)
      ** (Ecto.NoResultsError)

  """
  def get_channel!(id), do: Repo.get!(Channel, id)

  @spec get_channel_posts(Channel.t()) :: list(Post.t())
  def get_channel_posts(channel) do
    channel
    |> Repo.preload(:posts)
    |> Map.get(:posts)
  end

  @doc """
  Creates a channel.

  ## Examples

      iex> create_channel(%{field: value})
      {:ok, %Channel{}}

      iex> create_channel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_channel(any()) :: Channel.t()
  def create_channel(attrs \\ %{}) do
    %Channel{}
    |> Channel.changeset(attrs)
    |> Repo.insert()
  end

  @spec create_channel(any(), %{email: binary}) :: Channel.t()
  def create_channel(attrs, user) do
    with {:ok, channel} <- create_channel(attrs),
         channel <- add_channel_member(channel, user.email) do
      channel
    else
      _ ->
        {:error, "error"}
    end
  end

  @doc """
  Updates a channel.

  ## Examples

      iex> update_channel(channel, %{field: new_value})
      {:ok, %Channel{}}

      iex> update_channel(channel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_channel(%Channel{} = channel, attrs) do
    channel
    |> Channel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a channel.

  ## Examples

      iex> delete_channel(channel)
      {:ok, %Channel{}}

      iex> delete_channel(channel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_channel(%Channel{} = channel) do
    Repo.delete(channel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking channel changes.

  ## Examples

      iex> change_channel(channel)
      %Ecto.Changeset{data: %Channel{}}

  """
  def change_channel(%Channel{} = channel, attrs \\ %{}) do
    Channel.changeset(channel, attrs)
  end

  @doc """
  Add members to a channel.

  ## Examples

  iex> add_channel_members(channel, "foo@example.com)
  {:ok, %Channel{}}

  iex> add_channel_members(channel, "unknown@example.com"})
  {:error, %Ecto.Changeset{}}

  """
  @spec add_channel_member(Channel.t(), String.t()) :: Channel.t()
  def add_channel_member(%Channel{} = channel, email) do
    user = Accounts.get_user_by_email(email)

    with {:ok, _} <- create_member(%{user_id: user.id, channel_id: channel.id, role: :member}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Remove members to a channel.

  ## Examples

  iex> remove_channel_members(channel, "foo@example.com)
  {:ok, %Channel{}}

  iex> remove_channel_members(channel, "unknown@example.com"})
  {:error, %Ecto.Changeset{}}

  """
  @spec remove_channel_member(Channel.t(), String.t()) :: Channel.t()
  def remove_channel_member(%Channel{} = channel, email) do
    user = Accounts.get_user_by_email(email)

    query =
      from m in Member,
        where: m.user_id == ^user.id and m.channel_id == ^channel.id

    with {1, _} <-
           query
           |> Repo.delete_all() do
      get_channel!(channel.id)
    else
      {0, _} ->
        {:error, nil}
    end
  end

  @doc """
  Creates a member.

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @spec belong_to_channel?(atom(), Channel.t(), User.t()) :: boolean()
  def belong_to_channel?(role, channel, user) do
    query =
      from m in Member,
        where:
          m.user_id == ^user.id and
            m.channel_id == ^channel.id and
            m.role == ^role

    case Repo.one(query) do
      nil -> false
      _ -> true
    end
  end

  @spec is_channel_owner?(Channel.t(), User.t()) :: boolean()
  def is_channel_owner?(channel, user), do: belong_to_channel?(:owner, channel, user)
  @spec is_channel_member?(Channel.t(), User.t()) :: boolean()
  def is_channel_member?(channel, user), do: belong_to_channel?(:member, channel, user)
  @spec is_channel_pending?(Channel.t(), User.t()) :: boolean()
  def is_channel_pending?(channel, user), do: belong_to_channel?(:pending, channel, user)
  @spec is_channel_rejected?(Channel.t(), User.t()) :: boolean()
  def is_channel_rejected?(channel, user), do: belong_to_channel?(:rejected, channel, user)

  @doc """
  Add a post to a channel.
  """
  @spec add_post_to_channel(Channel.t(), User.t(), map()) ::
          Channel.t() | {:error, binary()}
  def add_post_to_channel(%Channel{} = channel, %User{} = user, attrs \\ %{}) do
    attrs = Map.merge(%{user_id: user.id, channel_id: channel.id}, attrs)

    with {:member_check, true} <- {:member_check, is_channel_member?(channel, user)},
         {:ok, _} <- create_post(attrs) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:member_check, false} ->
        {:error, "unauthorized"}
    end
  end

  def join_channel(%Channel{} = channel, %User{} = user) do
    with {:member_check, false} <- {:member_check, is_channel_member?(channel, user)},
         {:ok, _} <- create_member(%{user_id: user.id, channel_id: channel.id, role: :pending}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:member_check, true} ->
        {:error, "already a member"}
    end
  end

  def accept_pending_member_channel(%Channel{} = channel, %User{} = user, email) do
    with {:owner_check, true} <- {:owner_check, is_channel_owner?(channel, user)},
         {:user_exists, user} <- {:user_exists, Accounts.get_user_by_email(email)},
         {:user_pending, true} <- {:user_pending, is_channel_pending?(channel, user)},
         {:ok, _} <-
           update_member(user, %{user_id: user.id, channel_id: channel.id, role: :member}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:owner_check, false} ->
        {:error, "not the owner"}

      {:user_exists, nil} ->
        {:error, "user doen't exists"}

      {:user_pending, false} ->
        {:error, "user is not pending"}
    end
  end

  def reject_pending_member_channel(%Channel{} = channel, %User{} = user, email) do
    with {:owner_check, true} <- {:owner_check, is_channel_owner?(channel, user)},
         {:user_exists, user} <- {:user_exists, Accounts.get_user_by_email(email)},
         {:user_pending, true} <- {:user_pending, is_channel_pending?(channel, user)},
         {:ok, _} <-
           update_member(user, %{user_id: user.id, channel_id: channel.id, role: :rejected}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:owner_check, false} ->
        {:error, "not the owner"}

      {:user_exists, nil} ->
        {:error, "user doen't exists"}

      {:user_pending, false} ->
        {:error, "user is not pending"}
    end
  end
end
