defmodule RadiopushWeb.Components.ModalActions do
  use Surface.Component

  @doc "The main content"
  slot default

  def render(assigns) do
    ~F"""
    <div class="flex flex-row space-x-2 bottom-0 ring-2 ring-gray-800 left-0 w-full py-4 sticky bg-gray-800">
      <#slot />
    </div>
    """
  end
end
