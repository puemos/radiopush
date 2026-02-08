defmodule RadiopushWeb.Components.Reaction do
  use RadiopushWeb, :component

  attr :emoji, :string, required: true
  attr :count, :integer, required: true
  attr :click, :string, required: true
  attr :target, :any, default: nil

  def render(assigns) do
    ~H"""
    <button
      phx-click={@click}
      phx-target={@target}
      phx-value-emoji={@emoji}
      class="h-8 px-2.5 text-sm bg-gray-700 relative rounded-full flex flex-row items-center justify-center shadow-xl focus:outline-none"
    >
      <img class="w-4" title={@emoji} src={get_emoji_img(@emoji)} />
      <span class="text-xs font-bold ml-2"><%= @count %></span>
    </button>
    """
  end

  defp get_emoji_img(emoji) do
    Map.get(RadiopushWeb.Components.Emojis.all(), emoji)
  end
end
