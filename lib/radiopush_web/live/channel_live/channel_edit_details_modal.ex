defmodule RadiopushWeb.Components.ChannelEditDetailsModal do
  use Surface.LiveComponent

  alias RadiopushWeb.Components.{
    Button,
    Modal,
    ModalActions
  }

  alias Surface.Components.Form

  alias Surface.Components.Form.{
    Field,
    TextInput,
    TextArea,
    Checkbox
  }

  @doc "Post data"
  prop changeset, :changeset, required: true

  @doc "On form submit event"
  prop submit, :event, required: true

  @doc "On form delete event"
  prop delete, :event, required: true

  @doc "On url input change"
  prop change, :event, required: true

  @doc "Event to close the modal"
  prop close, :event, required: true

  data delete_verification, :string, default: ""

  def render(assigns) do
    ~F"""
    <Modal title="Settings">
      <Form for={@changeset} submit={@submit} opts={class: "h-full"}>
        <div class="h-full flex flex-col">
          <Field name={:description} class="w-full">
            <TextArea
              rows="4"
              opts={placeholder: "Channel description", style: "resize: none"}
              class="input w-full my-1"
            />
          </Field>
          <div class="flex flex-row justify-between space-x-2">
            <Field
              name={:private}
              class="flex items-center my-1 flex items-center justify-between py-2 w-full"
            >
              <span class="text-sm ml-1">Make private</span>
              <Checkbox class="h-5 w-5 text-primary-500 focus:ring-primary-500 border-gray-300 rounded" />
            </Field>
          </div>
          <div class="flex-1" />
          <div class="flex flex-row mb-2">
            <TextInput
              value={@delete_verification}
              keyup="keyup"
              opts={placeholder: "Type delete to verify", autocomplete: "off"}
              class="input border-2 ring-red-500 w-full mr-2 focus:ring-red-500"
            />
            <Button disabled={@delete_verification != "Delete"} click={@delete} color="danger">Delete</Button>
          </div>
          <ModalActions>
            <div class="flex flex-row w-full space-x-2">
              <Button click={@close} expand color="secondary">Close</Button>
              <Button type="submit" expand color="primary">Update</Button>
            </div>
          </ModalActions>
        </div>
      </Form>
    </Modal>
    """
  end

  def handle_event("keyup", %{"value" => value}, socket) do
    {:noreply, assign(socket, delete_verification: value)}
  end
end
