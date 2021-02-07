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
      |> assign_posts()
      |> assign_member_role()

    Presence.track_presence(
      self(),
      topic(id),
      socket.assigns.current_user.id,
      default_user_presence_payload(socket.assigns.current_user)
    )

    {:ok, socket}
  end

  defp assign_posts(socket) do
    with posts <- Channels.get_channel_posts(socket.assigns.channel) do
      assign(socket, posts: posts)
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
  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{id: id}}) do
    {:noreply,
     assign(socket,
       users: Presence.list_presences(topic(id))
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

    channel_id = socket.assigns.channel

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
      |> assign_posts()
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

  def render_rejected(assigns) do
    ~L"""
    <div>The channel owner rejected your request to join</div>
    """
  end

  def render_pending(assigns) do
    ~L"""
    <div>Please wait for the owner of the channel to approve your join request</div>
    """
  end

  def render_join(assigns) do
    ~L"""
    <form action="#" phx-submit="join">
    <%= submit "This channel is public, to join just click here", phx_disable_with: "Joining...", class: "button" %>
    </form>
    """
  end

  def render_channel(assigns) do
    ~L"""
    <div class="h-3/5">
    <div class="bg-gray-700 scrollbar scrollbar scrollbar-thin scrollbar-thumb-gray-900 scrollbar-track-gray-700 overflow-y-scroll h-full">
      <%=for post <- @posts do %>
        <div class="p-4 rounded-3xl" style="width: 400px">
          <iframe src="<%= iframe_src(post.url) %>" width="300" height="120" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>
          <div class="flex flex-row text-gray-300 text-xs pl-1 pt-1">
            <div><%= post.user.email %></div>
            <div>&nbsp;•&nbsp;</div>
            <div><%= post.inserted_at %></div>
          </div>
          </div>
      <% end %>
    </div>
    <form action="#" phx-submit="post" class="flex flex-row">
    <%= text_input :post, :url, placeholder: "Song", class: "flex-1 px-4 py-3 border-none text-sm font-medium placeholder-gray-400 text-white bg-gray-600 rounded-none group outline-none focus:outline-none focus:ring-0 w-full" %>
    <%= submit "Post", phx_disable_with: "Posting...", class: "button rounded-none" %>
    </form>
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1 class="text-4xl font-bold overflow-ellipsis overflow-hidden text-white-300">
    <%= @channel.name %>
    </h1>
    <div class="h-12"></div>
    <%= case @role do %>
      <% :owner -> %>
        <%= render_channel(assigns) %>
      <% :member -> %>
        <%= render_channel(assigns) %>
      <% :pending -> %>
        <%= render_pending(assigns) %>
      <% :rejected -> %>
        <%= render_rejected(assigns) %>
      <% true -> %>
        <%= render_join(assigns) %>
      <% nil -> %>
        <%= render_join(assigns) %>
    <% end %>
    """
  end

  def iframe_src(url) do
    cond do
      String.contains?(url, "spotify.com") ->
        String.replace(url, "https://open.spotify.com", "https://open.spotify.com/embed")

      String.contains?(url, "apple.com") ->
        String.replace(url, "https://music.apple.com/", "https://embed.music.apple.com/")
    end
  end
end
