defmodule RadiopushWeb.ChannelListLive.Index do
  use RadiopushWeb, :live_view
  alias Radiopush.Channels

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign_user_channels()
      |> assign_channels()
      |> assign_open_create_channel(false)

    {:ok, socket, temporary_assigns: [channels: []]}
  end

  defp assign_user_channels(socket) do
    user_channels = Channels.list_channels_by_user(socket.assigns.current_user)

    assign(socket, user_channels: user_channels)
  end

  defp assign_channels(socket) do
    with %{entries: channels, metadata: metadata} <-
           Channels.list_channels() do
      cursor_after = metadata.after

      assign(socket, channels: channels, cursor_after: cursor_after)
    end
  end

  defp assign_prev_channels(socket) do
    cursor_after = Map.get(socket.assigns, :cursor_after)

    if cursor_after == nil do
      socket
    else
      with %{entries: channels, metadata: metadata} <-
             Channels.list_channels(%{after: cursor_after}) do
        cursor_after = metadata.after
        assign(socket, channels: channels, cursor_after: cursor_after)
      end
    end
  end

  defp assign_open_create_channel(socket, flag) do
    assign(socket, open_create_channel: flag)
  end

  @impl true
  def handle_event("channel", %{"channel" => channel_params}, socket) do
    Radiopush.Channels.create_channel(socket.assigns.current_user, channel_params)

    socket =
      socket
      |> assign_user_channels()
      |> assign_open_create_channel(false)

    {:noreply, socket}
  end

  def handle_event("load-more", _params, socket) do
    socket =
      socket
      |> assign_prev_channels()

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
