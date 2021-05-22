defmodule RadiopushWeb.Components.EmojiPicker do
  use Surface.LiveComponent
  alias Surface.Components.Form.TextInput

  @doc "On emoji click"
  prop click, :event, required: true

  data emojis, :list, default: []
  data search, :string, default: ""

  def render(assigns) do
    ~H"""
    <div class="w-64 bg-gray-700 rounded-xl shadow-xl p-4">

      <TextInput value={{ @search }} keyup="keyup" opts={{ placeholder: "Search...", "phx-debounce": "200" }}
       class="flex-1 px-4 py-3 border-none text-sm font-medium placeholder-gray-400 text-white bg-gray-600 rounded-xl group outline-none focus:outline-none focus:ring-0 w-full" />
      <div class="mt-2 max-h-48 overflow-y-scroll grid grid-cols-7 grid-rows-7">
        <button :on-click={{@click}} phx-value-emoji={{name}} class="w-6 p-1 hover:bg-gray-800" :for={{ {name, img} <- @emojis}}>
          <img title={{name}} src={{img}} />
        </button>
      </div>
    </div>
    """
  end

  def mount(socket) do
    emojis = Enum.take(all_emojis(), 50)
    {:ok, assign(socket, emojis: emojis)}
  end

  def handle_event("keyup", %{"value" => value}, socket) do
    emojis = Enum.filter(all_emojis(), fn {name, _img} -> contains?(name, value) end)
    {:noreply, assign(socket, emojis: emojis)}
  end

  defp contains?(r, l) do
    String.contains?(String.downcase(r), String.downcase(l))
  end

  defp all_emojis do
    RadiopushWeb.Components.Emojis.all()
    |> Map.to_list()
    |> Enum.sort()
  end
end
