defmodule RadiopushWeb.Pages.Channels do
  @moduledoc false
  use RadiopushWeb, :live_view

  alias Radiopush.Channels
  alias Radiopush.Cmd.CreateChannel
  alias Radiopush.Qry.ListChannelsByCurrentUser
  alias RadiopushWeb.Components.{ChannelCard, NewChannelCard, NewChannelModal, Page}

  @impl true
  def render(assigns) do
    ~H"""
    <Page.render current_user={@context.user} path={@path}>
      <div>
        <NewChannelModal.render
          :if={@open_create_channel}
          close="close-create-channel"
          submit="channel"
          changeset={@channel_changeset}
        />

        <div class="flex flex-col justify-between items-start">
          <h1 class="text-2xl md:text-3xl font-bold overflow-ellipsis overflow-hidden text-white-300">
            My channels
          </h1>
          <div class="mt-2 text-sm text-gray-300">
            Here you can find your subscribed channels
          </div>
        </div>
        <div class="h-12" />
        <div class="grid grid-cols-2 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-4">
          <NewChannelCard.render click="open-create-channel" />
          <ChannelCard.render :for={channel <- @user_channels} channel={channel} card_click="card_click" />
        </div>
      </div>
    </Page.render>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign(user_channels_cursor: :init, user_channels: [], open_create_channel: false)
      |> assign_user_channels()
      |> assign_channel_changeset(Channels.change_channel())

    {:ok, socket, temporary_assigns: [user_channels: []]}
  end

  defp assign_user_channels(socket) do
    case socket.assigns.user_channels_cursor do
      nil ->
        socket

      :init ->
        {:ok, list, metadata} =
          ListChannelsByCurrentUser.run(
            socket.assigns.context,
            %ListChannelsByCurrentUser.Query{}
          )

        socket
        |> assign(user_channels: list)
        |> assign(user_channels_cursor: Map.get(metadata, :after, nil))

      cursor ->
        {:ok, list, metadata} =
          ListChannelsByCurrentUser.run(socket.assigns.context, %ListChannelsByCurrentUser.Query{
            cursor: cursor
          })

        socket
        |> assign(user_channels: list)
        |> assign(user_channels_cursor: Map.get(metadata, :after, nil))
    end
  end

  defp assign_open_create_channel(socket, flag) do
    assign(socket, open_create_channel: flag)
  end

  defp assign_channel_changeset(socket, channel_changeset) do
    assign(socket, channel_changeset: channel_changeset)
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{path: path} = URI.parse(uri)
    {:noreply, assign(socket, path: path)}
  end

  @impl true
  def handle_event("channel", %{"channel" => channel_params}, socket) do
    %{"description" => description, "name" => name, "private" => private} = channel_params

    case CreateChannel.run(socket.assigns.context, %CreateChannel.Cmd{
           description: description,
           name: name,
           private: private
         }) do
      {:ok, channel} ->
        {:noreply,
         push_navigate(socket,
           to: Routes.live_path(socket, RadiopushWeb.Pages.Channel, channel.name)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_channel_changeset(socket, changeset)}
    end
  end

  @impl true
  def handle_event("card_click", %{"name" => name}, socket) do
    {:noreply,
     push_navigate(socket,
       to: Routes.live_path(socket, RadiopushWeb.Pages.Channel, name)
     )}
  end

  @impl true
  def handle_event("open-create-channel", _, socket) do
    {:noreply, assign_open_create_channel(socket, true)}
  end

  @impl true
  def handle_event("close-create-channel", _, socket) do
    socket =
      socket
      |> assign_channel_changeset(Channels.change_channel())
      |> assign_open_create_channel(false)

    {:noreply, socket}
  end
end
