defmodule RadiopushWeb.Components.Button do
  use RadiopushWeb, :component

  attr :type, :string, default: "button"
  attr :label, :string, default: nil
  attr :aria_label, :string, default: nil
  attr :color, :string, default: nil
  attr :value, :string, default: nil
  attr :expand, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :click, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  slot :inner_block

  def render(assigns) do
    ~H"""
    <button
      type={@type}
      aria-label={@aria_label}
      phx-click={@click}
      disabled={@disabled}
      value={@value}
      class={[
        base_style(),
        @color == "primary" && "bg-primary-500",
        @color == "danger" && "bg-rose-500",
        @color == "secondary" && "bg-gray-600",
        @expand && "w-full",
        @disabled && "cursor-not-allowed opacity-50",
        @class
      ]}
      {@rest}
    >
      <%= if @inner_block == [] do %>
        <%= @label %>
      <% else %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </button>
    """
  end

  defp base_style do
    [
      "font-bold",
      "cursor-pointer",
      "px-4",
      "py-3",
      "text-sm",
      "text-white",
      "rounded-md",
      "group",
      "hover:bg-opacity-60",
      "focus:outline-none",
      "focus:ring-0",
      "transition-colors"
    ]
    |> Enum.join(" ")
  end
end
