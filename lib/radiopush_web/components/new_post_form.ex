defmodule RadiopushWeb.Components.NewPostForm do
  use Surface.LiveComponent

  alias RadiopushWeb.Components.{
    Button
  }

  alias Surface.Components.{
    Form
  }

  alias Surface.Components.Form.{
    Field,
    TextInput,
    Select,
  }

  @doc "Post data"
  prop post, :map, required: true

  @doc "On form submit event"
  prop submit, :event, required: true

  @doc "Current user's channels"
  prop channels, :list, default: []

  def render(assigns) do
    ~H"""
    <Form for={{ :post }} submit={{@submit}} class="rounded-xl shadow-xl overflow-hidden bg-gray-700">
      <div class="flex flex-row">
        <Field name="url" class="w-full">
          <TextInput value={{ @post["url"] }} opts={{ placeholder: "Song link from Spotify", autocomplete: "off" }} class="flex-1 px-4 py-3 border-none text-sm font-medium placeholder-gray-400 text-white bg-gray-700 rounded-none group outline-none focus:outline-none focus:ring-0 w-full"/>
        </Field>
        <Button type="submit" class="rounded-none bg-gray-700 hover:bg-gray-600">Post</Button>
      </div>
      <Field :if={{@channels != []}}  name="channel_id" class="w-full flex flex-row items-start py-2 bg-gray-600">
        <span class="pl-4 text-xs text-gray-300">Select a channel</span>
        <Select options={{make_options(@channels)}} opts={{ placeholder: "Channel", autocomplete: "off" }} class="py-0 text-xs bg-gray-600 flex-1 px-4 border-none text-sm font-medium placeholder-gray-300 text-white rounded-none group outline-none focus:outline-none focus:ring-0"/>
      </Field>
    </Form>
    """
  end

  defp make_options(channels) do
    channels
    |> Enum.map(fn channel -> {channel.name, channel.id} end)
    |> Enum.to_list()
  end
end
