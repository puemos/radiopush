defmodule RadiopushWeb.ChannelListLive.Index do
  use RadiopushWeb, :live_view
  alias Radiopush.Channels

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign_channels()

    {:ok, socket}
  end

  defp assign_channels(socket) do
    channels = Channels.list_channels()

    assign(socket, channels: channels)
  end

  @impl true
  def handle_event("channel", %{"channel" => channel_params}, socket) do
    Radiopush.Channels.create_channel(channel_params)

    {:noreply, assign_channels(socket)}
  end
end
