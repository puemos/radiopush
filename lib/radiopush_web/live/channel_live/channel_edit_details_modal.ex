defmodule RadiopushWeb.Components.ChannelEditDetailsModal do
  use RadiopushWeb, :live_component

  alias RadiopushWeb.Components.{Button, Modal, ModalActions}

  attr :changeset, :any, required: true
  attr :submit, :string, required: true
  attr :delete, :string, required: true
  attr :change, :string, default: nil
  attr :close, :string, required: true

  @impl true
  def mount(socket) do
    {:ok, assign(socket, delete_verification: "")}
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :form, to_form(assigns.changeset))

    ~H"""
    <Modal.render title="Settings">
      <form phx-submit={@submit} class="h-full">
        <div class="h-full flex flex-col">
          <textarea
            name={@form[:description].name}
            rows="4"
            placeholder="Channel description"
            style="resize: none"
            class="input w-full my-1"
          ><%= @form[:description].value %></textarea>

          <div class="flex flex-row justify-between space-x-2">
            <div class="flex items-center my-1 justify-between py-2 w-full">
              <span class="text-sm ml-1">Make private</span>
              <input type="hidden" name={@form[:private].name} value="false" />
              <input
                type="checkbox"
                name={@form[:private].name}
                value="true"
                checked={@form[:private].value}
                class="h-5 w-5 text-primary-500 focus:ring-primary-500 border-gray-300 rounded"
              />
            </div>
          </div>

          <div class="flex-1" />

          <div class="flex flex-row mb-2">
            <input
              type="text"
              value={@delete_verification}
              phx-keyup="keyup"
              phx-target={@myself}
              placeholder="Type delete to verify"
              autocomplete="off"
              class="input border-2 ring-red-500 w-full mr-2 focus:ring-red-500"
            />
            <Button.render
              disabled={@delete_verification != "Delete"}
              click={@delete}
              color="danger"
            >
              Delete
            </Button.render>
          </div>

          <ModalActions.render>
            <div class="flex flex-row w-full space-x-2">
              <Button.render click={@close} expand color="secondary">Close</Button.render>
              <Button.render type="submit" expand color="primary">Update</Button.render>
            </div>
          </ModalActions.render>
        </div>
      </form>
    </Modal.render>
    """
  end

  @impl true
  def handle_event("keyup", %{"value" => value}, socket) do
    {:noreply, assign(socket, delete_verification: value)}
  end
end
