defmodule RadiopushWeb.Components.ChannelMembersModal do
  use Surface.Component

  alias RadiopushWeb.Components.{
    Button,
    Modal,
    ModalActions
  }

  @doc "List of all members"
  prop members, :list

  @doc "Event to close the modal"
  prop close, :event, required: true

  def render(assigns) do
    ~H"""
    <Modal title="Members">
      <div class="h-full flex flex-col">
        <div class="flex flex-col space-y-1">
          <div class="grid grid-cols-1 gap-2">
            <div :for={{ member <- @members }} class="flex flex-row justify-between p-3 bg-gray-700 bg-opacity-40 rounded-xl">
              <div class="text-gray-300 text-sm">{{member.nickname}}</div>
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
end
