defmodule RadiopushWeb.Pages.Home do
  @moduledoc false
  use RadiopushWeb, :live_view

  alias Radiopush.{
    Channels
  }

  alias Radiopush.Cmd.{
    CreateChannel,
    DeleteOrAddPostReaction,
    AddUserToChannel,
    RemoveUserFromChannel,
    CreatePost
  }

  alias Radiopush.Qry.{
    ListPublicChannels,
    ListChannelsByCurrentUser,
    GetFeed,
    GetChannel
  }

  alias RadiopushWeb.Components.{
    PostCard,
    ChannelRow,
    Page,
    NewPostForm
  }

  @impl true
  def render(assigns) do
    ~H"""
    <Page.render current_user={@context.user} path={@path}>
      <div class="flex flex-row">
        <div phx-hook="InfiniteScroll" id="Home" class="flex-1">
          <div class="flex flex-col justify-between items-start">
            <h1 class="text-2xl md:text-3xl font-bold overflow-ellipsis overflow-hidden text-white-300">
              Home
            </h1>
            <div class="mt-2 text-sm text-gray-300">
              Latest posts from all your channels
            </div>
          </div>

          <div class="py-6">
            <NewPostForm.render channels={@user_channels} submit="post_submit" post={@post} />
          </div>

          <div
            :if={Enum.count(@new_feed) > 0}
            id="OldPosts"
            class="grid grid-cols-1 md:grid-cols-1 gap-4 w-full mb-4"
          >
            <.live_component
              :for={post <- @new_feed}
              module={PostCard}
              id={"post-#{post.id}"}
              nickname={post.user.nickname}
              post={post}
              channel={post.channel}
            />
          </div>
          <div id="NewPosts" class="grid grid-cols-1 md:grid-cols-1 gap-4 w-full mb-4">
            <.live_component
              :for={post <- @feed}
              module={PostCard}
              id={"post-#{post.id}"}
              nickname={post.user.nickname}
              post={post}
              channel={post.channel}
            />
          </div>
          <div class="h-6" />
        </div>
        <div class="hidden pt-20 px-4 relative lg:block lg:w-72 xl:w-5/12">
          <div class="top-6 sticky lg:flex flex-col space-y-4 w-full">
            <div class="p-3  relative flex flex-row items-start rounded-xl">
              <div class="flex flex-col w-full">
                <h3 class="text-lg font-bold mb-4">Latest public channels</h3>
                <div id="channels" class="top-6 sticky lg:flex flex-col space-y-4">
                  <div
                    :for={channel <- Enum.take(@public_channels, 4)}
                    class="border rounded-xl border-gray-700 border-opacity-30"
                    id={"s-#{channel.id}"}
                  >
                    <.live_component
                      module={ChannelRow}
                      id={"channel-#{channel.id}"}
                      channel={channel}
                      join_click="join_channel"
                      leave_click="leave_channel"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Page.render>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign(
        playlists: [],
        post: %{"url" => ""},
        public_channels: [],
        user_channels: [],
        feed_last_fetch: :init,
        feed_cursor: :init,
        new_feed: [],
        feed: [],
        open_create_channel: false,
        open_add_to_playlist: false
      )
      |> assign_feed()
      |> assign_public_channels()
      |> assign_user_channels()
      |> assign_channel_changeset(Channels.change_channel())

    {:ok, socket, temporary_assigns: [feed: [], public_channels: []]}
  end

  defp assign_new_feed(socket) do
    case socket.assigns.feed_last_fetch do
      :init ->
        socket

      feed_last_fetch ->
        {:ok, list} =
          GetFeed.run(
            socket.assigns.context,
            %GetFeed.Query{
              inserted_after: feed_last_fetch
            }
          )

        socket
        |> assign(new_feed: list)
        |> assign(feed_last_fetch: DateTime.utc_now())
    end
  end

  defp assign_feed(socket) do
    case socket.assigns.feed_cursor do
      nil ->
        socket

      :init ->
        {:ok, list, metadata} =
          GetFeed.run(
            socket.assigns.context,
            %GetFeed.Query{}
          )

        socket
        |> assign(feed: list)
        |> assign(feed_last_fetch: DateTime.utc_now())
        |> assign(feed_cursor: Map.get(metadata, :after, nil))

      cursor ->
        {:ok, list, metadata} =
          GetFeed.run(
            socket.assigns.context,
            %GetFeed.Query{
              cursor: cursor
            }
          )

        socket
        |> assign(feed: list)
        |> assign(feed_cursor: Map.get(metadata, :after, nil))
    end
  end

  defp assign_user_channels(socket) do
    {:ok, list, _} =
      ListChannelsByCurrentUser.run(
        socket.assigns.context,
        %ListChannelsByCurrentUser.Query{}
      )

    socket
    |> assign(user_channels: list)
  end

  defp assign_public_channels(socket) do
    {:ok, list, _metadata} =
      ListPublicChannels.run(
        socket.assigns.context,
        %ListPublicChannels.Query{
          name: ""
        }
      )

    socket
    |> assign(public_channels: list)
  end

  defp assign_post(socket, post) do
    socket
    |> assign(post: post)
  end

  # defp assign_user_playlists(socket) do
  #   {:ok, playlists} =
  #     ListUserPlaylists.run(
  #       socket.assigns.context,
  #       %ListUserPlaylists.Query{}
  #     )

  #   socket
  #   |> assign(playlists: playlists)
  # end

  defp assign_open_create_channel(socket, flag) do
    assign(socket, open_create_channel: flag)
  end

  defp assign_channel_changeset(socket, channel_changeset) do
    assign(socket, channel_changeset: channel_changeset)
  end

  defp update_post(socket, post) do
    socket
    |> update(:feed, fn feed -> [post | feed] end)
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{
      path: path
    } = URI.parse(uri)

    socket =
      socket
      |> assign(path: path)

    {:noreply, socket}
  end

  @impl true
  def handle_event("channel", %{"channel" => channel_params}, socket) do
    %{
      "description" => description,
      "name" => name,
      "private" => private
    } = channel_params

    case CreateChannel.run(
           socket.assigns.context,
           %CreateChannel.Cmd{
             description: description,
             name: name,
             private: private
           }
         ) do
      {:ok, channel} ->
        {:noreply,
         push_navigate(socket,
           to: Routes.live_path(socket, RadiopushWeb.Pages.Channel, channel.id)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign_channel_changeset(changeset)

        {:noreply, socket}
    end
  end

  def handle_event("join_channel", %{"value" => channel_id}, socket) do
    with {:ok} <-
           AddUserToChannel.run(
             socket.assigns.context,
             %AddUserToChannel.Cmd{
               channel_id: channel_id,
               user_id: socket.assigns.context.user.id
             }
           ),
         {:ok, channel} <-
           GetChannel.run(socket.assigns.context, %GetChannel.Query{
             channel_id: channel_id
           }) do
      channel = Map.merge(channel, %{joined: true})

      socket =
        socket
        |> update(:public_channels, fn channels -> [channel | channels] end)
        |> put_flash(:info, "You joined #{channel.name}")

      {:noreply, socket}
    else
      {:error, _error} ->
        {:noreply, put_flash(socket, :error, "Ops.. let's try again")}
    end
  end

  def handle_event("leave_channel", %{"value" => channel_id}, socket) do
    with {:ok, channel} <-
           GetChannel.run(socket.assigns.context, %GetChannel.Query{
             channel_id: channel_id
           }),
         {:ok} <-
           RemoveUserFromChannel.run(
             socket.assigns.context,
             %RemoveUserFromChannel.Cmd{
               channel_id: channel_id,
               user_id: socket.assigns.context.user.id
             }
           ) do
      channel = Map.merge(channel, %{joined: false})

      socket =
        socket
        |> update(:public_channels, fn channels -> [channel | channels] end)
        |> put_flash(:info, "You left #{channel.name} 😢")

      {:noreply, socket}
    else
      {:error, _error} ->
        {:noreply, put_flash(socket, :error, "Ops.. let's try again")}
    end
  end

  @impl true
  def handle_event(
        "post_submit",
        %{"post" => %{"url" => url, "channel_id" => channel_id}},
        socket
      ) do
    case CreatePost.run(socket.assigns.context, %CreatePost.Cmd{
           channel_id: channel_id,
           url: url
         }) do
      {:ok, _post} ->
        socket =
          socket
          |> assign_new_feed()
          |> assign_post(%{"url" => ""})
          |> put_flash(:info, "Your new post is shared!")

        {:noreply, socket}

      {:error, "Unauthorized"} ->
        socket = put_flash(socket, :error, "You are not permitted to post")
        {:noreply, socket}

      {:error, _} ->
        socket = put_flash(socket, :error, "We can only handle spotify links...")
        {:noreply, socket}
    end
  end

  def handle_event("load-more", _params, socket) do
    socket =
      socket
      |> assign_feed()

    {:noreply, socket}
  end

  @impl true
  def handle_event("open-create-channel", _, socket) do
    {:noreply, assign_open_create_channel(socket, true)}
  end

  @impl true
  def handle_event("close-add-to-playlist", _, socket) do
    {:noreply, assign(socket, open_add_to_playlist: false)}
  end

  @impl true
  def handle_event("close-create-channel", _, socket) do
    socket =
      socket
      |> assign_channel_changeset(Channels.change_channel())
      |> assign_open_create_channel(false)

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "delete_or_add_post_reaction", post_id: post_id, emoji: emoji}, socket) do
    case DeleteOrAddPostReaction.run(
           socket.assigns.context,
           %DeleteOrAddPostReaction.Cmd{
             post_id: post_id,
             emoji: emoji
           }
         ) do
      {:ok, post} ->
        {:noreply, update_post(socket, post)}

      {:error, "Unauthorized"} ->
        {:noreply, socket}

      {:error, _} ->
        socket = put_flash(socket, :error, "Ops.. let's try again")
        {:noreply, socket}
    end
  end

  # @impl true
  # def handle_info(%{event: "add_to_playlist", post_id: post_id}, socket) do
  #   socket =
  #     socket
  #     |> assign(open_add_to_playlist: true)

  #   {:noreply, socket}
  # end
end
