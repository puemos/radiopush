defmodule Radiopush.Channels.PostgresImpl do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Radiopush.Repo

  @type action :: Radiopush.Channels.Impl.action()

  alias Radiopush.Channels.{
    Channel,
    ChannelUser,
    Post,
    PostReaction
  }

  alias Radiopush.Accounts.{
    User
  }

  alias Radiopush.Infra

  @behaviour Radiopush.Channels.Impl

  # Channels

  @impl true
  def get_channel(id) when is_binary(id) do
    case Repo.get(Channel, id) do
      nil ->
        {:error, "NotFound"}

      channel ->
        {:ok, channel}
    end
  end

  @impl true
  def get_channel_by_name(name) when is_binary(name) do
    case Repo.get_by(Channel, name: name) do
      nil ->
        {:error, "NotFound"}

      channel ->
        {:ok, channel}
    end
  end

  @impl true
  def create_channel(attrs) do
    %Channel{}
    |> change_channel(attrs)
    |> Repo.insert()
  end

  @impl true
  def change_channel(%Channel{} = channel, attrs) do
    Channel.changeset(channel, attrs)
  end

  @impl true
  def change_channel() do
    Channel.changeset(%Channel{}, %{})
  end

  @impl true
  def update_channel(%Channel{} = channel, attrs) do
    channel
    |> change_channel(attrs)
    |> Repo.update()
  end

  @impl true
  def delete_channel(channel_id)
      when is_binary(channel_id) do
    query =
      from c in Channel,
        where: c.id == ^channel_id

    case Repo.delete_all(query) do
      {1, _} ->
        {:ok}

      nil ->
        {:error, "NotFound"}

      {0, _} ->
        {:error, "NotFound"}

      {:error, error} ->
        {:error, error}

      {:error} ->
        {:error}
    end
  end

  defp list_public_channels_query(opts) do
    name = Keyword.get(opts, :name, "")
    like_exp = "%#{name}%"

    from c in Channel,
      left_join: p in Post,
      as: :post,
      on: c.id == p.channel_id,
      join: cu in ChannelUser,
      as: :member,
      on: cu.channel_id == c.id,
      order_by: [desc: c.inserted_at],
      where: c.private == false and ilike(c.name, ^like_exp),
      group_by: [c.id],
      select_merge: %{
        total_posts: fragment("count(DISTINCT ?)", p.id),
        total_users: fragment("count(DISTINCT ?)", cu.user_id)
      }
  end

  @impl true
  def list_public_channels(opts) do
    cursor = Keyword.get(opts, :cursor, nil)

    query = list_public_channels_query(opts)

    %{entries: entries, metadata: metadata} =
      Repo.paginate(
        query,
        after: cursor,
        sort_direction: :desc,
        cursor_fields: [:inserted_at],
        limit: 50
      )

    metadata = Infra.PageMetadata.new(metadata)

    {:ok, entries, metadata}
  end

  # Members

  @impl true
  def is_user_in_channel(channel_id, user_id) when is_binary(channel_id) do
    query =
      from cu in ChannelUser,
        where:
          cu.user_id == ^user_id and
            cu.channel_id == ^channel_id

    case Repo.one(query) do
      nil ->
        {:ok, false}

      _ ->
        {:ok, true}
    end
  end

  @impl true
  def is_user_in_channel(channels_id, user_id) when is_list(channels_id) do
    query =
      from c in Channel,
        join: cu in ChannelUser,
        on: cu.channel_id == c.id,
        where: c.id in ^channels_id and cu.user_id == ^user_id,
        select: cu.channel_id

    case Repo.all(query) do
      list ->
        {:ok, list}
    end
  end

  defp list_users_by_channel_query(channel_id) do
    from u in User,
      join: cu in ChannelUser,
      on: u.id == cu.user_id,
      order_by: [desc: u.inserted_at],
      where: cu.channel_id == ^channel_id,
      select: u,
      group_by: u.id
  end

  @impl true
  def list_users_by_channel(channel_id, opts) do
    cursor = Keyword.get(opts, :cursor, nil)
    query = list_users_by_channel_query(channel_id)

    %{entries: entries, metadata: metadata} =
      Repo.paginate(
        query,
        after: cursor,
        sort_direction: :desc,
        cursor_fields: [:inserted_at],
        limit: 500
      )

    metadata = Infra.PageMetadata.new(metadata)

    {:ok, entries, metadata}
  end

  defp list_channels_by_user_query(user_id) do
    from c in Channel,
      join: cu in ChannelUser,
      on: c.id == cu.channel_id,
      left_join: p in Post,
      on: c.id == p.channel_id,
      order_by: [desc: c.inserted_at],
      where: cu.user_id == ^user_id,
      select: c,
      group_by: [c.id],
      select_merge: %{
        total_posts: fragment("count(DISTINCT ?)", p.id)
      }
  end

  @impl true
  def list_channels_by_user(user_id, opts) do
    cursor = Keyword.get(opts, :cursor, nil)
    query = list_channels_by_user_query(user_id)

    %{entries: entries, metadata: metadata} =
      Repo.paginate(
        query,
        after: cursor,
        sort_direction: :desc,
        cursor_fields: [:inserted_at],
        limit: 50
      )

    metadata = Infra.PageMetadata.new(metadata)

    {:ok, entries, metadata}
  end

  @impl true
  def add_user_to_channel(channel_id, user_id) do
    changeset =
      %ChannelUser{}
      |> ChannelUser.changeset(%{channel_id: channel_id, user_id: user_id})

    case Repo.insert(changeset) do
      {:ok, _} -> {:ok}
      {:error, _} -> {:error, "GenericError"}
    end
  end

  @impl true
  def remove_user_from_channel(channel_id, user_id) do
    query =
      from cg in ChannelUser,
        where: cg.channel_id == ^channel_id and cg.user_id == ^user_id

    case Repo.delete_all(query) do
      {1, _} ->
        {:ok}

      nil ->
        {:error, "NotFound"}

      {0, _} ->
        {:error, "NotFound"}

      {:error, error} ->
        {:error, error}

      {:error} ->
        {:error}
    end
  end

  # Posts

  @impl true
  def get_post(id) do
    query =
      from p in Post,
        where: p.id == ^id,
        preload: [:reactions, :user, :channel]

    case Repo.all(query) do
      nil -> {:error, "NotFound"}
      [] -> {:error, "NotFound"}
      [post] -> {:ok, post}
    end
  end

  @impl true
  def create_post(attrs) do
    %Post{}
    |> change_post(attrs)
    |> Repo.insert()
  end

  @impl true
  def change_post(%Post{} = post, attrs) do
    Post.changeset(post, attrs)
  end

  @impl true
  def update_post(%Post{} = post, attrs) do
    post
    |> change_post(attrs)
    |> Repo.update()
  end

  @impl true
  def delete_post(post_id)
      when is_binary(post_id) do
    query =
      from p in Post,
        where: p.id == ^post_id

    case Repo.delete_all(query) do
      {1, _} ->
        {:ok}

      nil ->
        {:error, "NotFound"}

      {0, _} ->
        {:error, "NotFound"}

      {:error, error} ->
        {:error, error}

      {:error} ->
        {:error}
    end
  end

  defp list_posts_by_channel_query(channel_id) do
    from p in Post,
      order_by: [desc: p.inserted_at],
      where: p.channel_id == ^channel_id,
      preload: [:reactions, :user, :channel]
  end

  @impl true
  def list_posts_by_channel(channel_id, opts) do
    cursor = Keyword.get(opts, :cursor, nil)
    query = list_posts_by_channel_query(channel_id)

    %{entries: entries, metadata: metadata} =
      Repo.paginate(
        query,
        after: cursor,
        sort_direction: :desc,
        cursor_fields: [:inserted_at],
        limit: 20
      )

    metadata = Infra.PageMetadata.new(metadata)

    {:ok, entries, metadata}
  end

  @impl true
  def list_posts_by_channel_after(channel_id, inserted_after) do
    query =
      from p in list_posts_by_channel_query(channel_id),
        where: p.inserted_at > ^inserted_after

    case Repo.all(query) do
      nil ->
        {:error, "NotFound"}

      list ->
        {:ok, list}
    end
  end

  # Feed

  defp get_feed_query(user_id) do
    from p in Post,
      join: c in Channel,
      on: c.id == p.channel_id,
      join: cu in ChannelUser,
      on: cu.channel_id == c.id,
      order_by: [desc: p.inserted_at],
      where: cu.user_id == ^user_id,
      preload: [:reactions, :user, :channel]
  end

  @impl true
  def get_feed(user_id, opts) do
    cursor = Keyword.get(opts, :cursor, nil)
    query = get_feed_query(user_id)

    %{entries: entries, metadata: metadata} =
      Repo.paginate(
        query,
        after: cursor,
        sort_direction: :desc,
        cursor_fields: [:inserted_at],
        limit: 20
      )

    metadata = Infra.PageMetadata.new(metadata)

    {:ok, entries, metadata}
  end

  @impl true
  def get_feed_after(user_id, inserted_after) do
    query =
      from p in get_feed_query(user_id),
        where: p.inserted_at > ^inserted_after

    case Repo.all(query) do
      nil ->
        {:error, "NotFound"}

      list ->
        {:ok, list}
    end
  end

  defp list_public_posts_query() do
    from p in Post,
      join: c in Channel,
      on: c.id == p.channel_id,
      order_by: [desc: p.inserted_at],
      where: c.private == false,
      preload: [:reactions, :user, :channel]
  end

  @impl true
  def list_public_posts(opts) do
    cursor = Keyword.get(opts, :cursor, nil)
    query = list_public_posts_query()

    %{entries: entries, metadata: metadata} =
      Repo.paginate(
        query,
        after: cursor,
        sort_direction: :desc,
        cursor_fields: [:inserted_at],
        limit: 20
      )

    metadata = Infra.PageMetadata.new(metadata)

    {:ok, entries, metadata}
  end

  @impl true
  def list_public_posts_after(inserted_after) do
    query =
      from p in list_public_posts_query(),
        where: p.inserted_at > ^inserted_after

    case Repo.all(query) do
      nil ->
        {:error, "NotFound"}

      list ->
        {:ok, list}
    end
  end

  # Post reactions
  @impl true
  def get_post_reaction(id) do
    query =
      from pr in PostReaction,
        where: pr.id == ^id,
        select: pr

    case Repo.all(query) do
      nil -> {:error, "NotFound"}
      [] -> {:error, "NotFound"}
      [post] -> {:ok, post}
    end
  end

  @impl true
  def get_post_reaction(user_id, post_id, emoji) do
    query =
      from pr in PostReaction,
        where:
          pr.user_id == ^user_id and
            pr.post_id == ^post_id and
            pr.emoji == ^emoji,
        select: pr

    case Repo.all(query) do
      nil -> {:error, "NotFound"}
      [] -> {:error, "NotFound"}
      [post] -> {:ok, post}
    end
  end

  @impl true
  def create_post_reaction(attrs) do
    %PostReaction{}
    |> PostReaction.changeset(attrs)
    |> Repo.insert()
  end

  @impl true
  def delete_post_reaction(post_reaction_id)
      when is_binary(post_reaction_id) do
    query =
      from pr in PostReaction,
        where: pr.id == ^post_reaction_id

    case Repo.delete_all(query) do
      {1, _} ->
        {:ok}

      nil ->
        {:error, "NotFound"}

      {0, _} ->
        {:error, "NotFound"}

      {:error, error} ->
        {:error, error}

      {:error} ->
        {:error}
    end
  end
end
