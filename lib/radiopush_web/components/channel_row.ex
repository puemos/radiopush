defmodule RadiopushWeb.Components.ChannelRow do
  use Surface.LiveComponent

  alias Surface.Components.{
    LiveRedirect
  }

  alias RadiopushWeb.Components.{
    Button,
    Card
  }

  @doc "The post data"
  prop channel, :map, required: true

  @doc "On join click"
  prop join_click, :event

  @doc "On leave click"
  prop leave_click, :event

  def render(assigns) do
    ~H"""
    <Card>
      <div id={{@id}} class={{"flex flex-row justify-between flex-initial w-full min-h-[4rem]"}}>
          <div class="flex flex-col justify-between items-start pr-2 space-y-2">
            <LiveRedirect class="text-sm font-bold text-gray-300 sp-underline primary hover:text-gray-100" to="/c/{{@channel.name}}">
              {{"#{@channel.name}"}}
            </LiveRedirect>
            <div class="flex flex-col space-y-2">
              <div class={{"text-sm text-gray-400 line-clamp-2 overflow-ellipsis overflow-hidden"}}>
                {{ @channel.description }}
              </div>
              <div class="flex flex-row space-x-2">
                <div class={{"text-xs text-gray-200 bg-gray-600 rounded-lg px-2"}}>
                  Posts {{ @channel.total_posts }}
                </div>
                <div class={{"text-xs text-gray-200 bg-gray-600 rounded-lg px-2"}}>
                  Members {{ @channel.total_users }}
                </div>
              </div>
            </div>
          </div>
          <div>
            <Button :if={{ !@channel.joined }} click={{@join_click}} value={{@channel.id}} class="bg-secondary-600">Join</Button>
            <Button :if={{ @channel.joined }} click={{@leave_click}} value={{@channel.id}} class="bg-opacity-0 border-2 border-secondary-600 hover:bg-secondary-600 hover:bg-opacity-100">Leave</Button>
          </div>
      </div>
    </Card>
    """
  end
end
