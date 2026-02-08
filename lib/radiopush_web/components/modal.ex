defmodule RadiopushWeb.Components.Modal do
  use RadiopushWeb, :component

  attr :title, :string, required: true
  slot :inner_block, required: true

  def render(assigns) do
    ~H"""
    <div
      id={"modal-#{@title}"}
      phx-hook="ScrollLock"
      class="z-50 fixed w-full h-full md:bg-opacity-50 bg-gray-800 top-0 left-0 md:py-10 flex justify-center items-center"
    >
      <div class="relative overflow-y-auto h-full w-full bg-gray-800 w-full max-w-2xl lg:w-9/12 md:px-10 md:rounded-xl">
        <h1 class="text-2xl md:text-3xl font-bold pt-4 md:pt-10 px-4 overflow-ellipsis overflow-hidden text-white-300 mb-4">
          <%= @title %>
        </h1>
        <div style="height: calc(100% - 6rem)" class="p-4">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end
end
