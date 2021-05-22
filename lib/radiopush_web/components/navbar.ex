defmodule RadiopushWeb.Components.Navbar do
  use Surface.Component

  alias Heroicons.{
    Solid,
    Outline
  }

  alias RadiopushWeb.Components.{
    NavbarLink
  }

  @doc "The current path"
  prop path, :string

  @impl true
  def render(assigns) do
    ~H"""
    <div
      class="flex fixed md:mt-4 bottom-0 left-0 md:py-1 w-full border-t border-gray-700 bg-gray-900 z-50 h-auto md:border-t-0 md:bg-opacity-100 md:py-0 md:justify-between md:pt-0 md:flex-col md:space-y-4 md:w-56 md:sticky md:top-6">
      <div class="flex flex-row md:-ml-2 md:flex-col md:space-y-4 justify-around w-full">

        <NavbarLink path={{@path}} to="/home" label="Home">
          <template slot="icon_solid"><Solid.HomeIcon class="w-6 h-6" /></template>
          <template slot="icon_outline"><Outline.HomeIcon class="w-6 h-6" /></template>
        </NavbarLink>

        <NavbarLink path={{@path}} to="/channels" label="My Channels">
          <template slot="icon_solid"><Solid.HeartIcon class="w-6 h-6" /></template>
          <template slot="icon_outline"><Outline.HeartIcon class="w-6 h-6" /></template>
        </NavbarLink>

        <NavbarLink path={{@path}} to="/explore" label="Explore">
          <template slot="icon_solid"><Solid.FireIcon class="w-6 h-6" /></template>
          <template slot="icon_outline"><Outline.FireIcon class="w-6 h-6" /></template>
        </NavbarLink>

      </div>
    </div>
    """
  end
end
