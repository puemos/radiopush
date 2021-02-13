defmodule RadiopushWeb.ChannelLive.Index do
  use RadiopushWeb, :live_view
  alias Radiopush.Channels
  alias Radiopush.Preview
  alias RadiopushWeb.Presence

  defp topic(channel_id), do: "channel:#{channel_id}"

  @impl true
  def mount(%{"id" => id}, session, socket) do
    RadiopushWeb.Endpoint.subscribe(topic(id))

    socket =
      socket
      |> assign_defaults(session)
      |> assign_channel(id)
      |> assign_init_posts()
      |> assign_member_role()

    Presence.track_presence(
      self(),
      topic(id),
      socket.assigns.current_user.id,
      default_user_presence_payload(socket.assigns.current_user)
    )

    {:ok, socket, temporary_assigns: [posts: []]}
  end

  defp assign_init_posts(socket) do
    with posts <- Channels.get_channel_posts(socket.assigns.channel) do
      assign(socket, posts: posts, last_inserted_at: get_last_inserted_at(posts))
    end
  end

  defp assign_posts(socket) do
    with posts <-
           Channels.get_channel_posts(
             socket.assigns.channel,
             socket.assigns.last_inserted_at
           ) do
      assign(socket, posts: posts, last_inserted_at: get_last_inserted_at(posts))
    end
  end

  defp assign_channel(socket, channel_id) do
    with channel <- Channels.get_channel!(channel_id) do
      assign(socket, channel: channel)
    end
  end

  defp assign_member_role(socket) do
    member =
      socket.assigns.channel
      |> Channels.get_member(socket.assigns.current_user)

    case member do
      nil -> assign(socket, role: nil)
      member -> assign(socket, role: member.role)
    end
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
  def handle_info(%{event: "message"}, socket) do
    {:noreply, assign_posts(socket)}
  end

  @impl true
  def handle_event("post", %{"post" => post_params}, socket) do
    metadata =
      post_params
      |> Map.get("url")
      |> Preview.get_metadata()

    Channels.new_post(
      socket.assigns.channel,
      socket.assigns.current_user,
      metadata
    )

    channel_id = socket.assigns.channel.id

    RadiopushWeb.Endpoint.broadcast_from(self(), topic(channel_id), "message", %{
      id: channel_id
    })

    {:noreply, assign_posts(socket)}
  end

  @impl true
  def handle_event("join", %{}, socket) do
    Channels.join(
      socket.assigns.channel,
      socket.assigns.current_user
    )

    socket =
      socket
      |> assign_init_posts()
      |> assign_member_role()

    {:noreply, socket}
  end

  defp default_user_presence_payload(user) do
    %{
      typing: false,
      email: user.email,
      user_id: user.id
    }
  end

  def iframe_src(url) do
    Preview.get_embed(url)
  end

  defp get_last_inserted_at(posts) do
    posts
    |> List.first()
    |> Map.get(:inserted_at)
  end
end
