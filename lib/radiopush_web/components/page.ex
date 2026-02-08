defmodule RadiopushWeb.Components.Page do
  use RadiopushWeb, :component

  alias RadiopushWeb.Components.{Footer, Header, Navbar}

  attr :path, :string, default: nil
  attr :current_user, :any, default: nil
  slot :inner_block, required: true

  def render(assigns) do
    ~H"""
    <div class="px-4 xl:px-24 mb-6 xl:m-auto max-w-screen-2xl">
      <.live_component module={Header} id="Header" current_user={@current_user} />
      <div class="w-full flex flex-row items-start">
        <Navbar.render :if={@path != "/"} path={@path} />
        <div class="flex-1">
          <%= render_slot(@inner_block) %>
          <Footer.render />
        </div>
      </div>
    </div>
    """
  end
end
