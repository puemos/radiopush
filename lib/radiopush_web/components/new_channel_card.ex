defmodule RadiopushWeb.Components.NewChannelCard do
  use Surface.Component

  @doc "on click"
  prop click, :event, required: true

  def render(assigns) do
    ~F"""
    <button
      :on-click={@click}
      class="group
      hover:shadow-md hover:filter hover:brightness-125
      duration-400
      transition-all
      bg-gray-700
      bg-opacity-40
      h-44
      md:h-52
      flex
      flex-col
      justify-between
      flex-initial
      p-4
      rounded-3xl
      overflow-hidden"
    >
      <div class="transition-all text-white font-bold text-xl md:text-2xl lg:text-3xl text-left flex flex-col justify-between">
        <div class="w-full pr-1 line-clamp-2 overflow-ellipsis overflow-hidden">
          + Create
        </div>
        <div class="w-full pr-1 line-clamp-2 overflow-ellipsis overflow-hidden">
          a new
        </div>
        <div class="w-full pr-1 line-clamp-2 overflow-ellipsis overflow-hidden">
          channel
        </div>
      </div>
    </button>
    """
  end
end
