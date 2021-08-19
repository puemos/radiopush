defmodule RadiopushWeb.Components.Card do
  use Surface.Component

  @doc "The main content"
  slot default

  def render(assigns) do
    ~F"""
    <div class="p-3 bg-gray-800 bg-opacity-40 relative flex flex-row items-start rounded-xl">
      <#slot />
    </div>
    """
  end
end
