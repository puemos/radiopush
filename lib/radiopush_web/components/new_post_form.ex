defmodule RadiopushWeb.Components.NewPostForm do
  use RadiopushWeb, :component

  alias RadiopushWeb.Components.Button

  attr :post, :map, required: true
  attr :submit, :string, required: true
  attr :channels, :list, default: []

  def render(assigns) do
    ~H"""
    <form phx-submit={@submit} class="rounded-xl shadow-xl overflow-hidden bg-gray-700">
      <div class="flex flex-row">
        <div class="w-full">
          <input
            type="text"
            name="post[url]"
            value={@post["url"]}
            placeholder="Song link from Spotify"
            autocomplete="off"
            class="flex-1 px-4 py-3 border-none text-sm font-medium placeholder-gray-400 text-white bg-gray-700 rounded-none group outline-none focus:outline-none focus:ring-0 w-full"
          />
        </div>
        <Button.render type="submit" class="rounded-none bg-gray-700 hover:bg-gray-600">Post</Button.render>
      </div>
      <div :if={@channels != []} class="w-full flex flex-row items-start py-2 bg-gray-600">
        <span class="pl-4 text-xs text-gray-300">Select a channel</span>
        <select
          name="post[channel_id]"
          class="py-0 text-xs bg-gray-600 flex-1 px-4 border-none text-sm font-medium placeholder-gray-300 text-white rounded-none group outline-none focus:outline-none focus:ring-0"
        >
          <option value="">Channel</option>
          <option :for={{name, id} <- make_options(@channels)} value={id}>{name}</option>
        </select>
      </div>
    </form>
    """
  end

  defp make_options(channels) do
    Enum.map(channels, fn channel -> {channel.name, channel.id} end)
  end
end
