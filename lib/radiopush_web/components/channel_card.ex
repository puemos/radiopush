defmodule RadiopushWeb.Components.ChannelCard do
  use Surface.Component

  @doc "The post data"
  prop channel, :map, required: true

  @doc "On card click"
  prop card_click, :event

  def render(assigns) do
    ~F"""
    <div
      :on-click={@card_click}
      phx-value-name={@channel.name}
      class="group
              duration-400
              hover:shadow-md hover:filter hover:brightness-125
              transition-all
              h-44
              min-w-[10rem]
              md:h-52
              flex
              flex-col
              justify-between
              flex-initial
              p-4
              rounded-3xl
              text-white
              shadow-offset-lime
              overflow-hidden
              cursor-pointer
              bg-primary-600"
    >
      <div class="flex flex-col justify-between">
        <div
          class="w-full pr-1 line-clamp-2 font-bold text-lg md:text-2xl lg:text-3xl overflow-ellipsis overflow-hidden"
          title={@channel.name}
        >
          {@channel.name}
        </div>
        <div :if={@channel.description} class="mt-1 w-full pr-1 text-sm line-clamp-2 md:line-clamp-3">
          {@channel.description}
        </div>
      </div>
      <div class="flex flex-col space-y-2">
        <div class="flex flex-row items-center justify-between">
          <div class="flex flex-row items-center">
            <div :if={@channel.private} class="flex flex-row" title="Private channel">
              <Heroicons.Solid.LockClosedIcon class="h-5 w-5" />
              <p class="text-sm">&nbsp;</p>
            </div>
            <div :if={!@channel.private} class="flex flex-row" title="Public channel">
              <Heroicons.Solid.GlobeAltIcon class="h-5 w-5" />
              <p class="text-sm">&nbsp;</p>
            </div>
          </div>
          <div class="flex flex-row items-center space-x-3">
            <div class="flex flex-row">
              <Heroicons.Solid.MusicNoteIcon class="h-5 w-5 mr-0.5" />
              <p class="text-sm">{@channel.total_posts}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
