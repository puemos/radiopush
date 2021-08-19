defmodule RadiopushWeb.Components.Reaction do
  use Surface.Component

  @doc "Emoji"
  prop emoji, :string, required: true

  @doc "How many?"
  prop count, :integer, required: true

  @doc "How many?"
  prop click, :event, required: true

  def render(assigns) do
    ~F"""
    <button
      :on-click={@click}
      phx-value-emoji={@emoji}
      class="h-8 px-2.5 text-sm bg-gray-700 relative rounded-full flex flex-row items-center justify-center shadow-xl focus:outline-none"
    >
      <img class="w-4" title={@emoji} src={get_emoji_img(@emoji)}>
      <span class="text-xs font-bold ml-2">{@count}</span>
    </button>
    """
  end

  defp get_emoji_img(emoji) do
    Map.get(RadiopushWeb.Components.Emojis.all(), emoji)
  end
end
