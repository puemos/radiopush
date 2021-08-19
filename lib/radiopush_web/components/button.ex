defmodule RadiopushWeb.Components.Button do
  use Surface.Component

  @doc """
  The button type, defaults to "button", mainly used for instances like modal X to close style buttons
  where you don't want to set a type at all. Setting to nil makes button have no type.
  """
  prop type, :string, default: "button"

  @doc "The label of the button, when no content (default slot) is provided"
  prop label, :string

  @doc "The aria label for the button"
  prop aria_label, :string

  @doc "The color of the button"
  prop color, :string, values: ~w(primary secondary link info success warning danger)

  @doc "The value for the button"
  prop value, :string

  @doc "Button is expanded (full-width)"
  prop expand, :boolean

  @doc "Set the button as disabled preventing the user from interacting with the control"
  prop disabled, :boolean

  @doc "Outlined style"
  prop outlined, :boolean

  @doc "Rounded style"
  prop rounded, :boolean

  @doc "Hovered style"
  prop hovered, :boolean

  @doc "Focused style"
  prop focused, :boolean

  @doc "Active style"
  prop active, :boolean

  @doc "Selected style"
  prop selected, :boolean

  @doc "Loading state"
  prop loading, :boolean

  @doc "Triggered on click"
  prop click, :event

  @doc "Css classes to propagate down to button. Default class if no class supplied is simply _button_"
  prop class, :css_class, default: []

  @doc """
  The content of the generated `<button>` element. If no content is provided,
  the value of property `label` is used instead.
  """
  slot default

  defp base_style() do
    classes = [
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

    Enum.join(classes, " ")
  end

  def render(assigns) do
    ~F"""
    <button
      type={@type}
      aria-label={@aria_label}
      :on-click={@click}
      disabled={@disabled}
      value={@value}
      class={[
        base_style(),
        "bg-primary-500": @color == "primary",
        "bg-rose-500": @color == "danger",
        "bg-gray-600": @color == "secondary",
        "w-full": @expand,
        "cursor-not-allowed opacity-50": @disabled
      ] ++ @class}
    >
      <#slot>{@label}</#slot>
    </button>
    """
  end
end
