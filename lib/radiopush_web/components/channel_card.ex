defmodule RadiopushWeb.Components.ChannelCard do
  use RadiopushWeb, :component

  attr :channel, :map, required: true
  attr :card_click, :string, default: nil

  def render(assigns) do
    ~H"""
    <div
      phx-click={@card_click}
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
          <%= @channel.name %>
        </div>
        <div :if={@channel.description} class="mt-1 w-full pr-1 text-sm line-clamp-2 md:line-clamp-3">
          <%= @channel.description %>
        </div>
      </div>
      <div class="flex flex-col space-y-2">
        <div class="flex flex-row items-center justify-between">
          <div class="flex flex-row items-center">
            <div :if={@channel.private} class="flex flex-row" title="Private channel">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c1.105 0 2 .895 2 2v4a2 2 0 11-4 0v-4c0-1.105.895-2 2-2zm6 0V9a6 6 0 10-12 0v2m12 0H6"/>
              </svg>
              <p class="text-sm">&nbsp;</p>
            </div>
            <div :if={!@channel.private} class="flex flex-row" title="Public channel">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.6 9h16.8M3.6 15h16.8M12 3a15.3 15.3 0 010 18M12 3a15.3 15.3 0 000 18" />
              </svg>
              <p class="text-sm">&nbsp;</p>
            </div>
          </div>
          <div class="flex flex-row items-center space-x-3">
            <div class="flex flex-row">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19V6l12-2v13M9 19a2 2 0 11-4 0 2 2 0 014 0zm12-2a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
              <p class="text-sm"><%= @channel.total_posts %></p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
