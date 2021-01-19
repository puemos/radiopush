defmodule Radiopush.Channels do
  @moduledoc """
  The Channels context.
  """

  import Ecto.Query, warn: false
  alias Radiopush.Repo

  alias Radiopush.Channels.{Channel, Member}
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
  Gets a single channel.

  Raises `Ecto.NoResultsError` if the Channel does not exist.

  ## Examples

      iex> get_channel!(123)
      %Channel{}

      iex> get_channel!(456)
      ** (Ecto.NoResultsError)

  """
  def get_channel!(id), do: Repo.get!(Channel, id)

  @doc """
  Creates a channel.

  ## Examples

      iex> create_channel(%{field: value})
      {:ok, %Channel{}}

      iex> create_channel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_channel(attrs \\ %{}) do
    %Channel{}
    |> Channel.changeset(attrs)
    |> Repo.insert()
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

    with {:ok, _} <- create_member(%{user_id: user.id, channel_id: channel.id}) do
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
end
