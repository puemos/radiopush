defmodule RadiopushWeb.ChannelLive.Index do
  use RadiopushWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign_channels()

    {:ok, socket}
  end

  defp assign_channels(socket) do
    socket
  end
end
