defmodule RadiopushWeb.Components.NavbarLink do
  use RadiopushWeb, :component

  attr :path, :string, required: true
  attr :to, :string, required: true
  attr :label, :string, required: true

  slot :icon_solid, required: true
  slot :icon_outline, required: true

  def render(assigns) do
    ~H"""
    <.link navigate={@to}>
      <div class={link_class(@to, @path)}>
        <%= if @to == @path do %>
          <%= render_slot(@icon_solid) %>
        <% else %>
          <%= render_slot(@icon_outline) %>
        <% end %>
        <span><%= @label %></span>
      </div>
    </.link>
    """
  end

  defp link_class(to, current) do
    active_class = if current == to, do: "text-primary-500 ", else: ""

    active_class <>
      "transition-colors flex flex-col text-xs font-semibold px-2 py-2 rounded-xl space-y-1 md:space-y-0 md:space-x-2 text-white md:font-bold md:text-xl justify-start items-center md:inline-flex md:flex-row md:pl-2 md:pr-4 md:hover:bg-gray-800 md:px-0"
  end
end
