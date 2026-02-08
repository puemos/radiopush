defmodule RadiopushWeb.Components.EmojiPicker do
  use RadiopushWeb, :live_component

  attr :click, :string, required: true
  attr :target, :any, default: nil

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-64 bg-gray-700 rounded-xl shadow-xl p-4">
      <input
        type="text"
        value={@search}
        phx-keyup="keyup"
        phx-target={@myself}
        phx-debounce="200"
        placeholder="Search..."
        class="flex-1 px-4 py-3 border-none text-sm font-medium placeholder-gray-400 text-white bg-gray-600 rounded-xl group outline-none focus:outline-none focus:ring-0 w-full"
      />
      <div class="mt-2 max-h-48 overflow-y-scroll grid grid-cols-7 grid-rows-7">
        <button
          :for={{name, img} <- @emojis}
          phx-click={@click}
          phx-target={@target}
          phx-value-emoji={name}
          class="w-6 p-1 hover:bg-gray-800"
        >
          <img title={name} src={img} />
        </button>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    emojis = Enum.take(all_emojis(), 50)
    {:ok, assign(socket, emojis: emojis, search: "")}
  end

  @impl true
  def handle_event("keyup", %{"value" => value}, socket) do
    emojis = Enum.filter(all_emojis(), fn {name, _img} -> contains?(name, value) end)
    {:noreply, assign(socket, emojis: emojis, search: value)}
  end

  defp contains?(right, left) do
    String.contains?(String.downcase(right), String.downcase(left))
  end

  defp all_emojis do
    RadiopushWeb.Components.Emojis.all()
    |> Map.to_list()
    |> Enum.sort()
  end
end
