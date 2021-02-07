defmodule RadiopushWeb.ChannelListLive.Index do
  use RadiopushWeb, :live_view
  alias Radiopush.Channels

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign_channels()
      |> assign_open_create_channel(false)

    {:ok, socket}
  end

  defp assign_channels(socket) do
    channels = Channels.list_channels()
    user_channels = Channels.list_channels_by_user(socket.assigns.current_user)

    assign(socket, channels: channels, user_channels: user_channels)
  end

  defp assign_open_create_channel(socket, flag) do
    assign(socket, open_create_channel: flag)
  end

  @impl true
  def handle_event("channel", %{"channel" => channel_params}, socket) do
    Radiopush.Channels.create_channel(socket.assigns.current_user, channel_params)

    socket =
      socket
      |> assign_channels()
      |> assign_open_create_channel(false)

    {:noreply, socket}
  end

  @impl true
  def handle_event("open-create-channel", _, socket) do
    {:noreply, assign_open_create_channel(socket, true)}
  end

  @impl true
  def handle_event("close-create-channel", _, socket) do
    {:noreply, assign_open_create_channel(socket, false)}
  end
end
