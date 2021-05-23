defmodule RadiopushWeb.Components.ChannelCard do
  use Surface.Component

  @doc "The post data"
  prop channel, :map, required: true

  @doc "On card click"
  prop card_click, :event

  def render(assigns) do
    ~H"""
    <div
      :on-click={{@card_click}}
      phx-value-name={{@channel.name}}
      class={{"group
              duration-400
              hover:shadow-md hover:filter hover:brightness-125
              transition-all
              h-44
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
              bg-gradient-to-br from-primary-600 to-secondary-600"
      }}>
      <div class="flex flex-col justify-between">
        <div class={{"w-full pr-1 line-clamp-2 font-bold text-lg md:text-2xl lg:text-3xl overflow-ellipsis overflow-hidden"}}
        title="{{ @channel.name }}">
          {{ @channel.name }}
        </div>
        <div :if={{@channel.description}} class="mt-1 w-full pr-1 text-sm line-clamp-2 md:line-clamp-3">
          {{ @channel.description }}
        </div>
      </div>
      <div class="flex flex-row justify-between items-end">

        <div :if={{ @channel.private }} title="Private channel">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
          </svg>
        </div>
        <div :if={{ !@channel.private }} title="Public channel">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M4.083 9h1.946c.089-1.546.383-2.97.837-4.118A6.004 6.004 0 004.083 9zM10 2a8 8 0 100 16 8 8 0 000-16zm0 2c-.076 0-.232.032-.465.262-.238.234-.497.623-.737 1.182-.389.907-.673 2.142-.766 3.556h3.936c-.093-1.414-.377-2.649-.766-3.556-.24-.56-.5-.948-.737-1.182C10.232 4.032 10.076 4 10 4zm3.971 5c-.089-1.546-.383-2.97-.837-4.118A6.004 6.004 0 0115.917 9h-1.946zm-2.003 2H8.032c.093 1.414.377 2.649.766 3.556.24.56.5.948.737 1.182.233.23.389.262.465.262.076 0 .232-.032.465-.262.238-.234.498-.623.737-1.182.389-.907.673-2.142.766-3.556zm1.166 4.118c.454-1.147.748-2.572.837-4.118h1.946a6.004 6.004 0 01-2.783 4.118zm-6.268 0C6.412 13.97 6.118 12.546 6.03 11H4.083a6.004 6.004 0 002.783 4.118z" clip-rule="evenodd" />
          </svg>
        </div>
        <div class="flex flex-row space-x-2">
          <div class={{"text-xs text-white border-white border rounded-lg px-2"}}>
            Posts {{ @channel.total_posts }}
          </div>
          <div class={{"text-xs text-white border-white border rounded-lg px-2"}}>
            Members {{ @channel.total_users }}
          </div>
        </div>
      </div>
    </div>
    """
  end
end
