defmodule RadiopushWeb.Components.NavbarLink do
  use Surface.Component

  alias Surface.Components.{
    LiveRedirect
  }

  @doc "The current path"
  prop path, :string, required: true

  @doc "The required path to link to."
  prop to, :string

  @doc "A text to present the page"
  prop label, :string, required: true

  @doc "An icon"
  slot icon_solid, required: true

  @doc "A full version of the same icon"
  slot icon_outline, required: true

  @impl true
  def render(assigns) do
    ~F"""
    <LiveRedirect to={@to}>
      <div class={link_class(@to, @path)}>
        <#slot :if={@to == @path} name="icon_solid" />
        <#slot :if={@to != @path} name="icon_outline" />
        <span>{@label}</span>
      </div>
    </LiveRedirect>
    """
  end

  defp link_class(to, current) do
    active_class =
      if current == to do
        "text-primary-500 "
      else
        ""
      end

    active_class <>
      "transition-colors flex flex-col text-xs font-semibold px-2 py-2 rounded-xl space-y-1 md:space-y-0 md:space-x-2 text-white md:font-bold md:text-xl justify-start items-center md:inline-flex md:flex-row md:pl-2 md:pr-4 md:hover:bg-gray-800 md:px-0"
  end
end
