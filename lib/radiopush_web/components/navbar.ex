defmodule RadiopushWeb.Components.Navbar do
  use RadiopushWeb, :component

  alias RadiopushWeb.Components.NavbarLink

  attr :path, :string, default: nil

  def render(assigns) do
    ~H"""
    <div class="flex fixed md:mt-4 bottom-0 left-0 md:py-1 w-full border-t border-gray-700 bg-gray-900 z-50 h-auto md:border-t-0 md:bg-opacity-100 md:py-0 md:justify-between md:pt-0 md:flex-col md:space-y-4 md:w-56 md:sticky md:top-6">
      <div class="flex flex-row md:-ml-2 md:flex-col md:space-y-4 justify-around w-full">
        <NavbarLink.render path={@path} to="/home" label="Home">
          <:icon_solid>
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 20 20" fill="currentColor">
              <path d="M10.707 1.707a1 1 0 00-1.414 0l-7 7A1 1 0 003 10.414V17a1 1 0 001 1h4a1 1 0 001-1v-3h2v3a1 1 0 001 1h4a1 1 0 001-1v-6.586a1 1 0 00.293-.707l-7-7z"/>
            </svg>
          </:icon_solid>
          <:icon_outline>
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7m-9 2v8m-4-8v8m8-8v8m4-10l2 2" />
            </svg>
          </:icon_outline>
        </NavbarLink.render>

        <NavbarLink.render path={@path} to="/channels" label="My Channels">
          <:icon_solid>
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 20 20" fill="currentColor">
              <path d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z"/>
            </svg>
          </:icon_solid>
          <:icon_outline>
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
            </svg>
          </:icon_outline>
        </NavbarLink.render>

        <NavbarLink.render path={@path} to="/explore" label="Explore">
          <:icon_solid>
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M11.3 1.046a1 1 0 00-1.6 0L8.24 3.03a1 1 0 01-.64.374l-2.358.343a1 1 0 00-.554 1.706l1.706 1.664a1 1 0 01.288.885l-.403 2.35a1 1 0 001.451 1.054L10 10.347l2.11 1.109a1 1 0 001.45-1.054l-.402-2.35a1 1 0 01.287-.885l1.706-1.664a1 1 0 00-.554-1.706l-2.357-.343a1 1 0 01-.64-.374L11.3 1.046z" clip-rule="evenodd"/>
            </svg>
          </:icon_solid>
          <:icon_outline>
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.046 3.22a1 1 0 00.95.69h3.387c.969 0 1.371 1.24.588 1.81l-2.74 1.99a1 1 0 00-.364 1.118l1.046 3.22c.3.921-.755 1.688-1.54 1.118l-2.74-1.99a1 1 0 00-1.176 0l-2.74 1.99c-.784.57-1.838-.197-1.539-1.118l1.045-3.22a1 1 0 00-.363-1.118l-2.74-1.99c-.784-.57-.38-1.81.588-1.81h3.387a1 1 0 00.95-.69l1.046-3.22z" />
            </svg>
          </:icon_outline>
        </NavbarLink.render>
      </div>
    </div>
    """
  end
end
