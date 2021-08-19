defmodule RadiopushWeb.Components.Page do
  use Surface.Component

  alias RadiopushWeb.Components.{
    Navbar,
    Footer,
    Header
  }

  @doc "The current path"
  prop path, :string

  @doc "The current logged in user"
  prop current_user, :any, default: nil

  @doc "The main content"
  slot default

  @impl true
  def render(assigns) do
    ~F"""
    <div class="px-4 xl:px-24 mb-6 xl:m-auto max-w-screen-2xl">
      <Header id="Header" current_user={@current_user} />
      <div class="w-full flex flex-row items-start">
        <Navbar :if={@path != "/"} path={@path} />
        <div class="flex-1">
          <#slot />
          <Footer />
        </div>
      </div>
    </div>
    """
  end
end
