defmodule RadiopushWeb.Components.ChannelInviteModal do
  use RadiopushWeb, :live_component

  alias Radiopush.Context
  alias Radiopush.Qry.ListUsersByNickname
  alias RadiopushWeb.Components.{Button, Modal, ModalActions}

  attr :close, :string, required: true
  attr :members, :list, default: []

  @impl true
  def mount(socket) do
    {:ok, list, _} =
      ListUsersByNickname.run(%Context{}, %ListUsersByNickname.Query{nickname: ""})

    {:ok, assign(socket, users: list, search: "")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Modal.render title="Invite someone">
      <div class="h-full flex flex-col">
        <input
          type="text"
          value={@search}
          phx-keyup="keyup"
          phx-target={@myself}
          placeholder="Search..."
          autocomplete="off"
          class="w-full px-4 py-3 border-none text-sm font-medium placeholder-gray-400 text-white bg-gray-600 rounded-xl group outline-none focus:outline-none focus:ring-0 w-full"
        />
        <div class="grid grid-cols-1 gap-2 mt-6">
          <div class="w-full" :for={user <- @users}>
            <button
              :if={!in_channel(@members, user)}
              phx-click="invite"
              phx-target={@myself}
              phx-value-user_id={user.id}
              phx-value-user_nickname={user.nickname}
              class="flex flex-row w-full justify-between p-3 bg-gray-700 bg-opacity-40 rounded-xl hover:bg-opacity-80"
            >
              <div class="text-gray-300 text-sm"><%= user.nickname %></div>
            </button>
            <div
              :if={in_channel(@members, user)}
              class="flex flex-row w-full justify-between p-3 bg-gray-700 bg-opacity-40 rounded-xl"
            >
              <div class="text-gray-300 text-sm"><%= user.nickname %></div>
              <div class="text-primary-300 text-sm">in channel</div>
            </div>
          </div>
        </div>
        <div class="flex-1" />
        <ModalActions.render>
          <Button.render click={@close} expand color="secondary">Close</Button.render>
        </ModalActions.render>
      </div>
    </Modal.render>
    """
  end

  @impl true
  def handle_event("keyup", %{"value" => value}, socket) do
    {:ok, list, _} =
      ListUsersByNickname.run(%Context{}, %ListUsersByNickname.Query{nickname: value})

    {:noreply, assign(socket, users: list, search: value)}
  end

  @impl true
  def handle_event(
        "invite",
        %{"user_id" => user_id, "user_nickname" => user_nickname},
        socket
      ) do
    send(self(), %{event: "invite", user_id: user_id, user_nickname: user_nickname})
    {:noreply, socket}
  end

  defp in_channel(members, user) do
    case Enum.find(members, false, fn member -> member.id == user.id end) do
      false -> false
      _ -> true
    end
  end
end
