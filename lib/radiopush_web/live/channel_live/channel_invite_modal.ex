defmodule RadiopushWeb.Components.ChannelInviteModal do
  use Surface.LiveComponent

  alias Surface.Components.Form.{
    TextInput
  }

  alias RadiopushWeb.Components.{
    Button,
    Modal,
    ModalActions
  }

  alias Radiopush.Qry.{
    ListUsersByNickname
  }

  alias Radiopush.Context

  @doc "Event to close the modal"
  prop close, :event, required: true

  @doc "List of all members"
  prop members, :list

  data users, :list, default: []
  data search, :string, default: ""

  @impl true
  def render(assigns) do
    ~H"""
    <Modal title="Invite someone">
      <div class="h-full flex flex-col">
        <TextInput value={{ @search }} keyup="keyup" opts={{ placeholder: "Search...", autocomplete: "off" }}
          class="w-full px-4 py-3 border-none text-sm font-medium placeholder-gray-400 text-white bg-gray-600 rounded-xl group outline-none focus:outline-none focus:ring-0 w-full" />
        <div class="grid grid-cols-1 gap-2 mt-6">
          <div class="w-full" :for={{ user <- @users }}>
            <button :if={{!in_channel(@members, user)}} :on-click="invite" phx-value-user_id={{user.id}} phx-value-user_nickname={{user.nickname}} class="flex flex-row w-full justify-between p-3 bg-gray-700 bg-opacity-40 rounded-xl hover:bg-opacity-80">
              <div class="text-gray-300 text-sm">{{ user.nickname }}</div>
            </button>
            <div :if={{in_channel(@members, user)}}  class="flex flex-row w-full justify-between p-3 bg-gray-700 bg-opacity-40 rounded-xl">
              <div class="text-gray-300 text-sm">{{ user.nickname }}</div>
              <div class="text-primary-300 text-sm">in channel</div>
            </div>
          </div>
        </div>
        <div class="flex-1"></div>
        <ModalActions>
          <Button click={{@close}} expand={{true}} color="secondary">Close</Button>
        </ModalActions>
      </div>
    </Modal>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, list, _} =
      ListUsersByNickname.run(%Context{}, %ListUsersByNickname.Query{
        nickname: ""
      })

    {:ok, assign(socket, users: list)}
  end

  @impl true

  def handle_event("keyup", %{"value" => value}, socket) do
    {:ok, list, _} =
      ListUsersByNickname.run(%Context{}, %ListUsersByNickname.Query{
        nickname: value
      })

    {:noreply, assign(socket, users: list)}
  end

  def handle_event(
        "invite",
        %{
          "user_id" => user_id,
          "user_nickname" => user_nickname
        },
        socket
      ) do
    send(self(), %{event: "invite", user_id: user_id, user_nickname: user_nickname})
    {:noreply, socket}
  end

  defp in_channel(members, user) do
    case Enum.find(members, false, fn m -> m.id == user.id end) do
      false -> false
      _ -> true
    end
  end
end
