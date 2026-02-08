defmodule RadiopushWeb.Components.ChannelMembersModal do
  use RadiopushWeb, :component

  alias RadiopushWeb.Components.{Button, Modal, ModalActions}

  attr :members, :list, default: []
  attr :close, :string, required: true

  def render(assigns) do
    ~H"""
    <Modal.render title="Members">
      <div class="h-full flex flex-col">
        <div class="flex flex-col space-y-1">
          <div class="grid grid-cols-1 gap-2">
            <div
              :for={member <- @members}
              class="flex flex-row justify-between p-3 bg-gray-700 bg-opacity-40 rounded-xl"
            >
              <div class="text-gray-300 text-sm"><%= member.nickname %></div>
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
end
