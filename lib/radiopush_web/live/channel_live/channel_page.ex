defmodule RadiopushWeb.Pages.Channel do
  use RadiopushWeb, :surface_view_helpers

  alias Radiopush.Channels

  alias Radiopush.Cmd.{
    UpdateChannel,
    DeleteChannel,
    AddUserToChannel,
    RemoveUserFromChannel,
    DeleteOrAddPostReaction,
    CreatePost
  }

  alias Radiopush.Qry.{
    GetChannel,
    ListPostsByChannel,
    ListUsersByChannel
  }

  alias RadiopushWeb.Presence

  alias RadiopushWeb.Components.{
    PostCard,
    NewPostForm,
    ChannelEditDetailsModal,
    ChannelInviteModal,
    ChannelMembersModal,
    Page
  }

  data initial_time, :any, default: DateTime.utc_now()

  data channel, :map
  data channel_changeset, :changeset

  data post, :map, default: %{"url" => ""}

  data new_posts, :list

  data posts, :list
  data posts_cursor, :string, default: :init

  data members, :list
  data members_cursor, :string, default: :init

  data open_members, :boolean, default: false
  data open_settings, :boolean, default: false
  data open_invitation, :boolean, default: false

  @impl true
  def render(assigns) do
    ~H"""
    <Page current_user={{@context.user}} path={{@path}}>
      <div phx-hook="InfiniteScroll" id="channel-page" class="w-full max-w-2xl flex flex-col md:flex-row justify-center">
        <div class="w-full flex-1 order-2 md:order-1" id="Notify" phx-hook="Notify">
          <div class="flex flex-row justify-between items-start">
            <div class="flex flex-col justify-between items-start">
              <h1 class="text-2xl md:text-3xl font-bold overflow-ellipsis overflow-hidden text-white-300">
                {{@channel.name}}
              </h1>
              <div :if={{@channel.description}} class="mt-2 text-sm text-gray-300">
                {{@channel.description}}
              </div>
            </div>
            <div class="flex flex-row">
              <button :on-click="leave_channel"
                      title="Leave channel"
                      class="ml-3 text-gray-100 hover:text-gray-300 text-red-500">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                </svg>
              </button>
              <button :on-click="open_settings"
                      :if={{@channel.owner_id == @context.user.id}}
                      class="ml-3 text-gray-100 hover:text-gray-300">
                <svg class="w-6 h-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
              </button>
              <button :on-click="open_invitation"
                      :if={{@channel.owner_id == @context.user.id}}
              class="ml-3 text-gray-100 hover:text-gray-300">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
                </svg>
              </button>
              <button :on-click="open_members"
              class="ml-3 text-gray-100 hover:text-gray-300">
                <svg class="w-6 h-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              </button>
            </div>
          </div>
          <div class="h-12"></div>
          <div>
            <NewPostForm id="new-post-form" submit="post_submit" post={{@post}} />
            <div class="h-6"></div>
            <div :if={{ Enum.count(@new_posts) > 0 }} id="NewPosts" phx-update="prepend" class="grid grid-cols-1 md:grid-cols-1 gap-4 w-full mb-4">
              <PostCard :for={{ post <- @new_posts }} id={{"post-#{post.id}"}} nickname={{post.user.nickname}}
                post={{post}} channel={{@channel}}/>
            </div>
            <div id="OldPosts"  phx-update="append" class="grid grid-cols-1 md:grid-cols-1 gap-4 w-full mb-4">
              <PostCard :for={{ post <- @posts }} id={{"post-#{post.id}"}} nickname={{post.user.nickname}}
                post={{post}} channel={{@channel}}/>
            </div>
            <div class="h-20"></div>
          </div>
        </div>
        <div style="z-index: 60" :if={{@channel.owner_id == @context.user.id and @open_invitation}}>
          <ChannelInviteModal id="invite-modal" close="close_invitation" members={{@members}} />
        </div>
        <div :if={{@open_members}}>
          <ChannelMembersModal close="close_members" members={{@members}}  />
        </div>
        <ChannelEditDetailsModal :if={{@channel.owner_id == @context.user.id and @open_settings}}
          id="channel_edit_details_modal"
          close="close_settings"
          submit="channel_details_submit"
          delete="channel_delete"
          change="channel_details_change"
          changeset={{@channel_changeset}} />
      </div>
    </Page>
    """
  end

  defp topic(channel_id), do: "channel:#{channel_id}"

  @impl true
  def mount(%{"name" => name}, session, socket) do
    socket = assign_defaults(socket, session)

    case GetChannel.run(socket.assigns.context, %GetChannel.Query{
           name: name
         }) do
      {:ok, channel} ->
        RadiopushWeb.Endpoint.subscribe(topic(channel.id))

        socket =
          socket
          |> assign_channel(channel)
          |> assign_channel_changeset(Channels.change_channel(channel, %{}))
          |> assign_channel_members()
          |> assign_channel_posts()

        Presence.track_presence(
          self(),
          topic(channel.id),
          socket.assigns.context.user.id,
          default_user_presence_payload(socket.assigns.context.user)
        )

        {:ok, socket, temporary_assigns: [posts: [], new_posts: []]}

      {:error, _} ->
        {:ok,
         push_redirect(
           socket,
           to: Routes.live_path(socket, RadiopushWeb.Pages.Home)
         )}
    end
  end

  defp assign_new_channel_posts(socket) do
    channel_id = socket.assigns.channel.id
    inserted_after = socket.assigns.posts_last_fetch

    {:ok, list} =
      ListPostsByChannel.run(
        socket.assigns.context,
        %ListPostsByChannel.Query{
          channel_id: channel_id,
          inserted_after: inserted_after
        }
      )

    socket
    |> assign(new_posts: list)
    |> assign(posts_last_fetch: DateTime.utc_now())
  end

  defp assign_channel_posts(socket) do
    channel_id = socket.assigns.channel.id

    case socket.assigns.posts_cursor do
      nil ->
        socket

      :init ->
        {:ok, list, metadata} =
          ListPostsByChannel.run(
            socket.assigns.context,
            %ListPostsByChannel.Query{
              channel_id: channel_id
            }
          )

        socket
        |> assign(posts: list)
        |> assign(posts_last_fetch: DateTime.utc_now())
        |> assign(posts_cursor: Map.get(metadata, :after, nil))

      cursor ->
        {:ok, list, metadata} =
          ListPostsByChannel.run(
            socket.assigns.context,
            %ListPostsByChannel.Query{
              channel_id: channel_id,
              cursor: cursor
            }
          )

        socket
        |> assign(posts: list)
        |> assign(posts_cursor: Map.get(metadata, :after, nil))
    end
  end

  defp assign_channel_members(socket) do
    channel_id = socket.assigns.channel.id
    IO.inspect(socket.assigns.members_cursor)

    case socket.assigns.members_cursor do
      nil ->
        socket

      :init ->
        {:ok, list, metadata} =
          ListUsersByChannel.run(
            socket.assigns.context,
            %ListUsersByChannel.Query{
              channel_id: channel_id
            }
          )

        socket
        |> assign(members: list)
        |> assign(members_cursor: Map.get(metadata, :after, nil))

      cursor ->
        {:ok, list, metadata} =
          ListUsersByChannel.run(
            socket.assigns.context,
            %ListUsersByChannel.Query{
              channel_id: channel_id,
              cursor: cursor
            }
          )

        socket
        |> assign(members: list)
        |> assign(members_cursor: Map.get(metadata, :after, nil))
    end
  end

  defp update_post(socket, post) do
    initial_time = socket.assigns.initial_time

    case post.inserted_at > initial_time do
      false ->
        socket
        |> update(:posts, fn posts -> [post | posts] end)

      true ->
        socket
        |> update(:new_posts, fn new_posts -> [post | new_posts] end)
    end
  end

  defp assign_channel(socket, channel) do
    assign(socket, channel: channel)
  end

  defp assign_open_settings(socket, flag) do
    assign(socket, open_settings: flag)
  end

  defp assign_open_invitation(socket, flag) do
    assign(socket, open_invitation: flag)
  end

  defp assign_open_members(socket, flag) do
    assign(socket, open_members: flag)
  end

  defp assign_post(socket, post) do
    assign(socket, :post, post)
  end

  defp assign_channel_changeset(socket, changeset) do
    assign(socket, :channel_changeset, changeset)
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
  def handle_info(%{event: "presence_diff"}, socket) do
    channel_id = socket.assigns.channel.id

    {:noreply,
     assign(socket,
       users: Presence.list_presences(topic(channel_id))
     )}
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{event: "message", payload: %{post: post}},
        socket
      ) do
    channel = socket.assigns.channel
    notification = create_notification(post, channel)

    socket =
      socket
      |> assign_new_channel_posts()
      |> push_event("notify", %{
        notification: notification
      })

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{event: "post_update", payload: %{post: post}},
        socket
      ) do
    {:noreply, update_post(socket, post)}
  end

  @impl true
  def handle_info(%{event: "invite", user_id: user_id, user_nickname: user_nickname}, socket) do
    channel_id = socket.assigns.channel.id

    case AddUserToChannel.run(
           socket.assigns.context,
           %AddUserToChannel.Cmd{
             channel_id: channel_id,
             user_id: user_id
           }
         ) do
      {:ok} ->
        socket =
          socket
          |> assign(members_cursor: :init)
          |> assign_channel_members()
          |> put_flash(:info, "You invited #{user_nickname}")

        {:noreply, socket}

      {:error, "Unauthorized"} ->
        socket = put_flash(socket, :error, "You are not permitted to add new members")
        {:noreply, socket}

      {:error, _} ->
        socket = put_flash(socket, :error, "Ops.. let's try again")
        {:noreply, socket}
    end
  end

  def handle_info(%{event: "delete_or_add_post_reaction", post_id: post_id, emoji: emoji}, socket) do
    case DeleteOrAddPostReaction.run(
           socket.assigns.context,
           %DeleteOrAddPostReaction.Cmd{
             post_id: post_id,
             emoji: emoji
           }
         ) do
      {:ok, post} ->
        RadiopushWeb.Endpoint.broadcast_from(self(), topic(post.channel_id), "post_update", %{
          post: post
        })

        {:noreply, update_post(socket, post)}

      {:error, "Unauthorized"} ->
        {:noreply, socket}

      {:error, _} ->
        socket = put_flash(socket, :error, "Ops.. let's try again")
        {:noreply, socket}
    end
  end

  def handle_event("load-more", _params, socket) do
    socket =
      socket
      |> assign_channel_posts()

    {:noreply, socket}
  end

  @impl true
  def handle_event("post_submit", %{"post" => %{"url" => url}}, socket) do
    channel_id = socket.assigns.channel.id

    case CreatePost.run(socket.assigns.context, %CreatePost.Cmd{
           channel_id: channel_id,
           url: url
         }) do
      {:ok, post} ->
        RadiopushWeb.Endpoint.broadcast_from(
          self(),
          topic(channel_id),
          "message",
          %{
            id: channel_id,
            post: post
          }
        )

        socket =
          socket
          |> assign_new_channel_posts()
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

  @impl true
  def handle_event("channel_details_submit", %{"channel" => params}, socket) do
    channel_id = socket.assigns.channel.id
    %{"description" => description, "private" => private} = params

    case UpdateChannel.run(socket.assigns.context, %UpdateChannel.Cmd{
           channel_id: channel_id,
           description: description,
           private: private
         }) do
      {:ok, channel} ->
        socket =
          socket
          |> assign_channel(channel)
          |> assign_open_settings(false)
          |> assign_channel_changeset(Channels.change_channel(channel, %{}))

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign_channel_changeset(changeset)
          |> put_flash(:error, "Ops.. let's try again")

        {:noreply, socket}

      {:error, "Unauthorized"} ->
        socket = put_flash(socket, :error, "You are not permitted to change details")
        {:noreply, socket}

      {:error, _} ->
        socket = put_flash(socket, :error, "Ops.. let's try again")
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("channel_delete", _, socket) do
    channel_id = socket.assigns.channel.id

    case DeleteChannel.run(socket.assigns.context, %DeleteChannel.Cmd{
           channel_id: channel_id
         }) do
      {:ok} ->
        {:noreply,
         push_patch(socket,
           to: Routes.live_path(socket, RadiopushWeb.Pages.Home)
         )}

      {:error, "Unauthorized"} ->
        socket = put_flash(socket, :error, "You are not permitted to delete")
        {:noreply, socket}

      {:error, _} ->
        socket = put_flash(socket, :error, "Ops.. let's try again")
        {:noreply, socket}
    end
  end

  def handle_event("leave_channel", _, socket) do
    case RemoveUserFromChannel.run(
           socket.assigns.context,
           %RemoveUserFromChannel.Cmd{
             channel_id: socket.assigns.channel.id,
             user_id: socket.assigns.context.user.id
           }
         ) do
      {:ok} ->
        {:noreply,
         push_redirect(socket,
           to: Routes.live_path(socket, RadiopushWeb.Pages.Home)
         )}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("open_settings", _, socket) do
    {:noreply, assign_open_settings(socket, true)}
  end

  @impl true
  def handle_event("close_settings", _, socket) do
    {:noreply, assign_open_settings(socket, false)}
  end

  @impl true
  def handle_event("open_invitation", _, socket) do
    {:noreply, assign_open_invitation(socket, true)}
  end

  @impl true
  def handle_event("close_invitation", _, socket) do
    {:noreply, assign_open_invitation(socket, false)}
  end

  @impl true
  def handle_event("open_members", _, socket) do
    {:noreply, assign_open_members(socket, true)}
  end

  @impl true
  def handle_event("close_members", _, socket) do
    {:noreply, assign_open_members(socket, false)}
  end

  defp create_notification(post, channel) do
    body =
      case post.type do
        "song" -> "#{post.song} by #{post.musician}"
        "album" -> "#{post.album} by #{post.musician}"
      end

    title = "New post on #{channel.name}"

    notification = %{
      title: title,
      body: body,
      img: post.image
    }

    notification
  end

  defp default_user_presence_payload(user) do
    %{
      email: user.email
    }
  end
end
