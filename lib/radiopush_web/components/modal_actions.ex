defmodule RadiopushWeb.Components.ModalActions do
  use RadiopushWeb, :component

  slot :inner_block, required: true

  def render(assigns) do
    ~H"""
    <div class="flex flex-row space-x-2 bottom-0 ring-2 ring-gray-800 left-0 w-full py-4 sticky bg-gray-800">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
