defmodule RadiopushWeb.Components.Header do
  use Surface.LiveComponent

  alias Surface.Components.{
    Link,

  }

  @doc "The current logged in user"
  prop current_user, :any

  data menu_open, :boolean, default: false

  @impl true
  def render(assigns) do
    ~H"""
    <nav class="flex flex-row justify-between items-center w-full bg-gray-900 top-0 left-0 z-50 py-3">
      <div class="flex space-x-4 items-baseline">
        <Link to={{"/"}} class="py-2 rounded-md ">
          <div class="flex flex-row items-center space-x-2">
            <img class="w-9 h-9" src="{{"/images/radiopush-logo.svg"}}"/>
            <span class="font-bold text-2xl text-white hidden md:block">Radiopush</span>
          </div>
        </Link>
      </div>
      <div class="flex space-x-4">
        <div class="relative" id="menu" data-id={{"menu"}} data-event="click-outside-user-menu">
          <div :if={{@current_user}} :on-click="open-menu" class="cursor-pointer flex flex-row items-center space-x-2 rounded-3xl bg-gray-700 capitalize text-gray-100 py-1 px-2 text-sm font-bold">
            <div>{{@current_user.nickname}}</div>
            <img class="w-8 h-8 rounded-full border-gray-500 border" src={{@current_user.image}}>
          </div>

          <div :if={{@menu_open}} class="z-50 absolute right-0 w-40 mt-2 bg-gray-700 rounded shadow-xl">
            <Link to={{RadiopushWeb.Router.Helpers.user_session_path(@socket, :delete)}}>
              <div class="transition-colors text-sm font-semibold duration-200 block px-4 py-4 text-normal text-white rounded hover:bg-gray-600 hover:text-white">
                Logout
              </div>
            </Link>
          </div>

        </div>
      </div>
    </nav>
    """
  end

  @impl true
  def handle_event("click-outside-user-menu", _params, socket) do
    {:noreply, assign(socket, menu_open: false)}
  end

  def handle_event("open-menu", _params, socket) do
    {:noreply, assign(socket, menu_open: !socket.assigns.menu_open)}
  end
end
