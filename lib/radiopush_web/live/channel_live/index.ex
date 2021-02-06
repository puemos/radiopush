defmodule RadiopushWeb.ChannelLive.Index do
  use RadiopushWeb, :live_view
  alias Radiopush.Channels
  alias Radiopush.Preview

  def render_rejected(assigns) do
    ~L"""
    <h1><%= @channel.name %></h1>
    <div>The channel owner rejected your request to join</div>
    """
  end

  def render_pending(assigns) do
    ~L"""
    <h1><%= @channel.name %></h1>
    <div>Please wait for the owner of the channel to approve your join request</div>
    """
  end

  def render_join(assigns) do
    ~L"""
    <h1><%= @channel.name %></h1>
    <div>Join Channel</div>
    <form action="#" phx-submit="join">
    <%= submit "Join", phx_disable_with: "Joining..." %>
    </form>
    """
  end

  def render_channel(assigns) do
    ~L"""
    <h1><%= @channel.name %></h1>
    <div>
      <%=for post <- @posts do %>
        <div>
          <div><%= post.song %></div>
          <div><%= post.album %></div>
          <div><%= post.musician %></div>
          <div><%= post.url %></div>
          <div><%= post.image %></div>
        </div>
      <% end %>
    </div>
    <form action="#" phx-submit="post">
      <%= text_input :post, :url, placeholder: "Song" %>
      <%= submit "Create", phx_disable_with: "Creating..." %>
    </form>
    """
  end

  @impl true
  def render(assigns) do
    ~L"""
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
    <% end %>
    """
  end

  @impl true
  def mount(%{"id" => id}, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign_channel(id)
      |> assign_posts()
      |> assign_member_role()

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
    role =
      socket.assigns.channel
      |> Channels.get_channel_members()
      |> Enum.find(fn m -> m.user_id == socket.assigns.current_user.id end)
      |> Map.get(:role)

    assign(socket, role: role)
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

    {:noreply, assign_posts(socket)}
  end

  @impl true
  def handle_event("join", %{}, socket) do
    channel =
      Channels.join(
        socket.assigns.channel,
        socket.assigns.current_user
      )

    {:noreply, assign_channel(socket, channel.id)}
  end
end
