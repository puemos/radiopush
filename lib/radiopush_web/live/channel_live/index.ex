defmodule RadiopushWeb.ChannelLive.Index do
  use RadiopushWeb, :live_view
  alias Radiopush.Channels

  @impl true
  def mount(%{"id" => id}, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign_channel(id)
      |> assign_posts()

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

  @impl true
  def handle_event("post", %{"post" => post_params}, socket) do
    Radiopush.Channels.add_post_to_channel(
      socket.assigns.channel,
      socket.assigns.current_user,
      post_params
    )

    {:noreply, assign_posts(socket)}
  end
end
