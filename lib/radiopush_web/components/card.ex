defmodule RadiopushWeb.Components.Card do
  use RadiopushWeb, :component

  slot :inner_block, required: true

  def render(assigns) do
    ~H"""
    <div class="p-3 bg-gray-800 bg-opacity-40 relative flex flex-row items-start rounded-xl">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
