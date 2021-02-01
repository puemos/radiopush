defmodule Radiopush.Channels do
  @moduledoc """
  The Channels context.
  """

  import Ecto.Query, warn: false
  alias Radiopush.Repo

  alias Radiopush.Channels.{Channel, Member, Post}
  alias Radiopush.Accounts
  alias Radiopush.Accounts.{User}

  def list_channels do
    Repo.all(Channel)
  end

  def list_channels_by_user(user) do
    user
    |> Repo.preload(:channels)
    |> Map.get(:channels)
  end

  def get_channel!(id), do: Repo.get!(Channel, id)

  @spec get_channel_posts(Channel.t()) :: list(Post.t())
  def get_channel_posts(channel) do
    channel
    |> Repo.preload(:posts)
    |> Map.get(:posts)
  end

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

  def update_channel(%Channel{} = channel, attrs) do
    channel
    |> Channel.changeset(attrs)
    |> Repo.update()
  end

  def delete_channel(%Channel{} = channel) do
    Repo.delete(channel)
  end

  def change_channel(%Channel{} = channel, attrs \\ %{}) do
    Channel.changeset(channel, attrs)
  end

  def get_member!(channel_id, user_id),
    do: Repo.get_by!(Member, channel_id: channel_id, user_id: user_id)

  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_member(Radiopush.Channels.Member.t()) :: {:ok, struct()} | {:error, String}
  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  @spec delete_member(Channel.t(), User.t()) :: {:ok, 1} | {:error, binary()}
  def delete_member(channel, user) do
    query =
      from m in Member,
        where: m.user_id == ^user.id and m.channel_id == ^channel.id

    case Repo.delete_all(query) do
      {1, nil} -> {:ok, 1}
    end
  end

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @spec belong_to_channel?(Channel.t(), User.t(), list(atom())) :: boolean()
  def belong_to_channel?(channel, user, roles) do
    query =
      from m in Member,
        where:
          m.user_id == ^user.id and
            m.channel_id == ^channel.id and
            m.role in ^roles

    case Repo.one(query) do
      nil -> false
      _ -> true
    end
  end

  @spec is_channel_owner?(Channel.t(), User.t()) :: boolean()
  def is_channel_owner?(channel, user), do: belong_to_channel?(channel, user, [:owner])
  @spec is_channel_member?(Channel.t(), User.t()) :: boolean()
  def is_channel_member?(channel, user), do: belong_to_channel?(channel, user, [:member, :owner])
  @spec is_channel_pending?(Channel.t(), User.t()) :: boolean()
  def is_channel_pending?(channel, user), do: belong_to_channel?(channel, user, [:pending])
  @spec is_channel_rejected?(Channel.t(), User.t()) :: boolean()
  def is_channel_rejected?(channel, user), do: belong_to_channel?(channel, user, [:rejected])

  @spec add_post_to_channel(Channel.t(), User.t(), map()) ::
          Channel.t() | {:error, binary()}
  def add_post_to_channel(channel, user, attrs \\ %{}) do
    post =
      %Post{}
      |> Post.changeset_data(attrs)
      |> Post.changeset_assoc(%{user_id: user.id, channel_id: channel.id})

    with {:member_check, true} <- {:member_check, is_channel_member?(channel, user)},
         {:ok, _} <- Repo.insert(post) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:member_check, false} ->
        {:error, "unauthorized"}
    end
  end

  @spec add_channel_member(Channel.t(), User.t()) :: Channel.t()
  def add_channel_member(channel, user) do
    with {:ok, _} <- create_member(%{user_id: user.id, channel_id: channel.id, role: :member}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:user, nil} ->
        {:error, "user doen't exits"}
    end
  end

  @spec add_channel_owner(Channel.t(), User.t()) :: Channel.t()
  def add_channel_owner(channel, user) do
    with {:ok, _} <- create_member(%{user_id: user.id, channel_id: channel.id, role: :owner}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:user, nil} ->
        {:error, "user doen't exits"}
    end
  end

  @doc """
  Remove members to a channel.
  """
  @spec remove_channel_member(Channel.t(), User.t()) :: Channel.t()
  def remove_channel_member(channel, user) do
    with {:delete, {:ok, 1}} <- {:delete, delete_member(channel, user)} do
      get_channel!(channel.id)
    else
      {:user, nil} ->
        {:error, "user doen't exits"}

      {:delete, {:error, error}} ->
        {:error, error}
    end
  end

  @spec join_channel(Channel.t(), User.t()) :: Channel.t()
  def join_channel(channel, user) do
    with {:member_check, false} <- {:member_check, is_channel_member?(channel, user)},
         {:ok, _} <- create_member(%{user_id: user.id, channel_id: channel.id, role: :pending}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:member_check, true} ->
        {:error, "already a member"}

      {:user, nil} ->
        {:error, "user doen't exits"}
    end
  end

  @spec accept_pending_member(Channel.t(), User.t(), User.t()) :: Channel.t()

  def accept_pending_member(channel, owner, user) do
    with {:owner_check, true} <- {:owner_check, is_channel_owner?(channel, owner)},
         {:user_pending, true} <- {:user_pending, is_channel_pending?(channel, user)},
         {:member, member} <- {:member, get_member!(channel.id, user.id)},
         {:ok, _} <-
           update_member(member, %{user_id: user.id, channel_id: channel.id, role: :member}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:owner_check, false} ->
        {:error, "not the owner"}

      {:user_pending, false} ->
        {:error, "user is not pending"}
    end
  end

  @spec reject_pending_member(Channel.t(), User.t(), User.t()) :: Channel.t()
  def reject_pending_member(channel, owner, user) do
    with {:owner_check, true} <- {:owner_check, is_channel_owner?(channel, owner)},
         {:user_pending, true} <- {:user_pending, is_channel_pending?(channel, user)},
         {:member, member} <- {:member, get_member!(channel.id, user.id)},
         {:ok, _} <-
           update_member(member, %{user_id: user.id, channel_id: channel.id, role: :rejected}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:owner_check, false} ->
        {:error, "not the owner"}

      {:user_pending, false} ->
        {:error, "user is not pending"}
    end
  end
end
