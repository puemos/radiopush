defmodule RadiopushWeb.Pages.Explore do
  @moduledoc false
  use RadiopushWeb, :surface_view_helpers

  alias Radiopush.Qry.{
    ListPublicChannels,
    GetChannel
  }

  alias Radiopush.Cmd.{
    AddUserToChannel,
    RemoveUserFromChannel
  }

  alias RadiopushWeb.Components.{
    ChannelRow,
    Page
  }

  alias Surface.Components.Form.{
    TextInput
  }

  data public_channels_search, :string, default: ""
  data public_channels_cursor, :string, default: :init
  data public_channels, :list

  @impl true
  def render(assigns) do
    ~H"""
    <Page current_user={{@context.user}} path={{@path}}>
      <div>
        <div class="flex flex-col justify-between items-start">
          <h1 class="text-2xl md:text-3xl font-bold overflow-ellipsis overflow-hidden text-white-300">
            Explore
          </h1>
          <div class="mt-2 text-sm text-gray-300">
            Find new channels, search among all the avalible public channels
          </div>
        </div>
        <div class="h-6"></div>

        <TextInput value={{ @public_channels_search }} keyup="public_channels_search_keyup" opts={{ placeholder: "Search...", autocomplete: "off" }}
          class="flex-1 px-4 py-3 border-none text-sm font-medium placeholder-gray-400 text-white bg-gray-600 rounded-xl group outline-none focus:outline-none focus:ring-0 w-full" />

        <div class="h-6"></div>

        <div
          id="channels"
          class="grid grid-cols-1 sm:grid-cols-1 md:grid-cols-1 xl:grid-cols-2 gap-4">
            <ChannelRow :for={{channel <- @public_channels}} id={{"channel-#{channel.name}"}} channel={{channel}} join_click="join_channel" leave_click="leave_channel"/>
        </div>
        <div class="h-6"></div>
      </div>
    </Page>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign_public_channels()

    {:ok, socket}
  end

  defp assign_public_channels(socket) do
    case socket.assigns.public_channels_cursor do
      nil ->
        socket

      :init ->
        {:ok, list, metadata} =
          ListPublicChannels.run(
            socket.assigns.context,
            %ListPublicChannels.Query{
              name: socket.assigns.public_channels_search
            }
          )

        socket
        |> assign(public_channels: list)
        |> assign(public_channels_cursor: Map.get(metadata, :after, nil))

      cursor ->
        {:ok, list, metadata} =
          ListPublicChannels.run(
            socket.assigns.context,
            %ListPublicChannels.Query{
              cursor: cursor,
              name: socket.assigns.public_channels_search
            }
          )

        socket
        |> assign(public_channels: list)
        |> assign(public_channels_cursor: Map.get(metadata, :after, nil))
    end
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{
      path: path
    } = URI.parse(uri)

    socket =
      socket
      |> assign(path: path)

    {:noreply, socket}
  end

  @impl true
  def handle_event("public_channels_search_keyup", %{"value" => value}, socket) do
    socket =
      socket
      |> assign(public_channels_search: value)
      |> assign(public_channels_cursor: :init)
      |> assign_public_channels()

    {:noreply, socket}
  end

  def handle_event("join_channel", %{"value" => channel_id}, socket) do
    with {:ok} <-
           AddUserToChannel.run(
             socket.assigns.context,
             %AddUserToChannel.Cmd{
               channel_id: channel_id,
               user_id: socket.assigns.context.user.id
             }
           ),
         {:ok, channel} <-
           GetChannel.run(socket.assigns.context, %GetChannel.Query{
             channel_id: channel_id
           }) do
      channel = Map.merge(channel, %{joined: true})

      socket =
        socket
        |> update(:public_channels, fn channels -> [channel | channels] end)
        |> put_flash(:info, "You joined #{channel.name}")

      {:noreply, socket}
    else
      {:error, _error} ->
        {:noreply, put_flash(socket, :error, "Ops.. let's try again")}
    end
  end

  def handle_event("leave_channel", %{"value" => channel_id}, socket) do
    with {:ok, channel} <-
           GetChannel.run(socket.assigns.context, %GetChannel.Query{
             channel_id: channel_id
           }),
         {:ok} <-
           RemoveUserFromChannel.run(
             socket.assigns.context,
             %RemoveUserFromChannel.Cmd{
               channel_id: channel_id,
               user_id: socket.assigns.context.user.id
             }
           ) do
      channel = Map.merge(channel, %{joined: false})

      socket =
        socket
        |> update(:public_channels, fn channels -> [channel | channels] end)
        |> put_flash(:info, "You left #{channel.name} 😢")

      {:noreply, socket}
    else
      {:error, _error} ->
        {:noreply, put_flash(socket, :error, "Ops.. let's try again")}
    end
  end

  def handle_event("load-more", _params, socket) do
    socket =
      socket
      |> assign_public_channels()

    {:noreply, socket}
  end
end
