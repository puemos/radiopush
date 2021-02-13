defmodule Radiopush.Channels do
  @moduledoc """
  The Channels context.
  """

  import Ecto.Query, warn: false
  alias Radiopush.Repo

  alias Radiopush.Channels.{Channel, Member, Post}
  alias Radiopush.Accounts.{User}

  # Channels

  def list_channels do
    query =
      from c in Channel,
        where: c.private == false

    Repo.all(query)
  end

  def list_channels_by_user(user) do
    user
    |> Repo.preload(:channels)
    |> Map.get(:channels)
  end

  def get_channel!(id), do: Repo.get!(Channel, id)

  @spec get_channel_posts(Channel.t()) :: list(Post.t())
  def get_channel_posts(channel) do
    query =
      from p in Post,
        where: p.channel_id == ^channel.id,
        preload: :user,
        order_by: [desc: p.inserted_at]

    Repo.all(query)
  end

  @spec get_channel_posts(Channel.t(), NaiveDateTime.t()) :: list(Post.t())
  def get_channel_posts(channel, last) do
    query =
      from p in Post,
        where:
          p.channel_id == ^channel.id and
            p.inserted_at > ^last,
        preload: :user,
        order_by: [desc: p.inserted_at]

    Repo.all(query)
  end

  @spec get_channel_members(Channel.t()) :: list(Member.t())
  def get_channel_members(channel) do
    channel
    |> Repo.preload(:members)
    |> Map.get(:members)
  end

  @spec create_channel(any()) :: Channel.t()
  def create_channel(attrs \\ %{}) do
    %Channel{}
    |> Channel.changeset(attrs)
    |> Repo.insert()
  end

  @spec create_channel(User.t(), any()) :: Channel.t()
  def create_channel(owner, attrs) do
    {:ok, channel} = create_channel(attrs)

    create_member(%{
      user_id: owner.id,
      channel_id: channel.id,
      role: :owner
    })

    {:ok, get_channel!(channel.id)}
  end

  def update_channel(%Channel{} = channel, attrs) do
    channel
    |> Channel.changeset(attrs)
    |> Repo.update()
  end

  def update_channel_private(%Channel{} = channel, attrs) do
    channel
    |> Channel.private_changeset(attrs)
    |> Repo.update()
  end

  def delete_channel(%Channel{} = channel) do
    Repo.delete(channel)
  end

  # members

  def get_member(channel, user),
    do: Repo.get_by(Member, channel_id: channel.id, user_id: user.id)

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

  def update_member_role(%Member{} = member, attrs) do
    member
    |> Member.changeset_role(attrs)
    |> Repo.update()
  end

  @spec delete_member(Radiopush.Channels.Member.t()) :: {:ok, struct()} | {:error, String}
  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  @doc """
  Check if a member have permission to manage channel members.
  """
  @spec can_manage_members?(Member.t()) :: boolean()
  def can_manage_members?(member), do: member.role == :owner

  @doc """
  Check if a member have permission to post on a channel.
  """
  @spec can_publish?(Member.t()) :: boolean()
  def can_publish?(member), do: Enum.member?([:owner, :member], member.role)

  @spec add_user(Channel.t(), User.t(), User.t(), atom()) :: Channel.t()
  defp add_user(channel, u_owner, u_member, role) do
    with {:get_owner, owner} when not is_nil(owner) <- {:get_owner, get_member(channel, u_owner)},
         {:can_manage_members?, true} <-
           {:can_manage_members?, can_manage_members?(owner)},
         {:add, {:ok, _member}} <-
           {:add,
            create_member(%{
              user_id: u_member.id,
              channel_id: channel.id,
              role: role
            })} do
      get_channel!(channel.id)
    else
      {:get_owner, nil} ->
        {:error, "not an owner"}

      {:get_member, nil} ->
        {:error, "not a member"}

      {:can_manage_members?, false} ->
        {:error, "not allowed to manage members"}

      {:add, {:error, error}} ->
        {:error, error}
    end
  end

  @doc """
  Adds a user as owner to a channel.
  """
  @spec add_owner(Channel.t(), User.t(), User.t()) :: Channel.t()
  def add_owner(channel, owner, user), do: add_user(channel, owner, user, :owner)

  @doc """
  Adds a user as member to a channel.
  """
  @spec add_member(Channel.t(), User.t(), User.t()) :: Channel.t()
  def add_member(channel, owner, user), do: add_user(channel, owner, user, :member)

  @doc """
  Remove a user from a channel.
  """
  @spec remove_user(Channel.t(), User.t(), User.t()) :: Channel.t()
  def remove_user(channel, u_owner, u_member) do
    with {:get_owner, owner} when not is_nil(owner) <- {:get_owner, get_member(channel, u_owner)},
         {:can_manage_members?, true} <-
           {:can_manage_members?, can_manage_members?(owner)},
         {:get_member, member} when not is_nil(member) <-
           {:get_member, get_member(channel, u_member)},
         {:delete, {:ok, _member}} <- {:delete, delete_member(member)} do
      get_channel!(channel.id)
    else
      {:get_owner, nil} ->
        {:error, "not an owner"}

      {:get_member, nil} ->
        {:error, "not a member"}

      {:can_manage_members?, false} ->
        {:error, "not allowed to manage members"}

      {:delete, {:error, error}} ->
        {:error, error}
    end
  end

  @doc """
  Ask to join a channel
  """
  @spec join(Channel.t(), User.t()) :: Channel.t()
  def join(channel, user) do
    role = if channel.private, do: :pending, else: :member

    with {:exists, nil} <- {:exists, get_member(channel, user)},
         {:create, {:ok, _}} <-
           {:create,
            create_member(%{
              user_id: user.id,
              channel_id: channel.id,
              role: role
            })} do
      get_channel!(channel.id)
    else
      {:create, {:error, error}} ->
        {:error, error}

      {:exists, _} ->
        {:error, "already a member"}
    end
  end

  @doc """
  Accept a pending user to a channel.
  """
  @spec accept_user(Channel.t(), User.t(), User.t()) :: Channel.t()
  def accept_user(channel, u_owner, u_member) do
    with {:get_owner, owner} when not is_nil(owner) <- {:get_owner, get_member(channel, u_owner)},
         {:can_manage_members?, true} <- {:can_manage_members?, can_manage_members?(owner)},
         {:get_member, member} when not is_nil(member) <-
           {:get_member, get_member(channel, u_member)},
         {:user_pending, true} <- {:user_pending, member.role == :pending},
         {:ok, _} <- update_member_role(member, %{role: :member}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:get_owner, nil} ->
        {:error, "not an owner"}

      {:get_member, nil} ->
        {:error, "not a member"}

      {:can_manage_members?, false} ->
        {:error, "not allowed to manage members"}

      {:user_pending, false} ->
        {:error, "user is not pending"}
    end
  end

  @doc """
  Reject a pending user to a channel.
  """
  @spec reject_user(Channel.t(), User.t(), User.t()) :: Channel.t()
  def reject_user(channel, u_owner, u_member) do
    with {:get_owner, owner} when not is_nil(owner) <- {:get_owner, get_member(channel, u_owner)},
         {:can_manage_members?, true} <- {:can_manage_members?, can_manage_members?(owner)},
         {:get_member, member} when not is_nil(member) <-
           {:get_member, get_member(channel, u_member)},
         {:user_pending, true} <- {:user_pending, member.role == :pending},
         {:ok, _} <- update_member_role(member, %{role: :rejected}) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:get_owner, nil} ->
        {:error, "not an owner"}

      {:get_member, nil} ->
        {:error, "not a member"}

      {:can_manage_members?, false} ->
        {:error, "not allowed to manage members"}

      {:user_pending, false} ->
        {:error, "user is not pending"}
    end
  end

  # post

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Add a new post to a channel.
  """
  @spec new_post(Channel.t(), User.t(), map()) ::
          Channel.t() | {:error, binary()}
  def new_post(channel, u_member, post_attrs \\ %{}) do
    post =
      %Post{}
      |> Post.changeset_data(post_attrs)
      |> Post.changeset_assoc(%{user_id: u_member.id, channel_id: channel.id})

    with {:get_member, member} when not is_nil(member) <-
           {:get_member, get_member(channel, u_member)},
         {:can_publish?, true} <- {:can_publish?, can_publish?(member)},
         {:ok, _} <- Repo.insert(post) do
      get_channel!(channel.id)
    else
      {:error, error} ->
        {:error, error}

      {:get_member, nil} ->
        {:error, "not a member"}

      {:can_publish?, false} ->
        {:error, "unauthorized"}
    end
  end
end
