defmodule RadiopushWeb.HomeLive.Index do
  use RadiopushWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
