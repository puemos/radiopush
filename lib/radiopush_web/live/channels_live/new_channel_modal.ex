defmodule RadiopushWeb.Components.NewChannelModal do
  use Surface.Component

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
    Checkbox,
    ErrorTag
  }

  @doc "Post data"
  prop changeset, :changeset, required: true

  @doc "On form submit event"
  prop submit, :event, required: true

  @doc "Event to close the modal"
  prop close, :event, required: true

  def render(assigns) do
    ~F"""
    <Modal title="New channel">
      <Form for={@changeset} submit={@submit} opts={class: "h-full"}>
        <div class="h-full flex flex-col">
          <div class="flex flex-row justify-between space-x-2">
            <Field name={:name} class="w-full">
              <div class="flex flex-row space-x-1 py-1">
                <div class="text-sm text-gray-300">
                  Note that this cannot be changed later, including capitalisation.
                </div>
                <div title="Must be between 3-21 characters long, cannot have spaces, underscores are the only special characters allowed.">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path
                      fill-rule="evenodd"
                      d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </div>
              </div>
              <TextInput opts={placeholder: "Channel name"} class="input w-full my-1" />
              <ErrorTag class="text-sm text-red-500" />
            </Field>
          </div>
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
          <ModalActions>
            <div class="flex flex-row w-full space-x-2">
              <Button click={@close} expand color="secondary">Close</Button>
              <Button type="submit" expand color="primary">Create</Button>
            </div>
          </ModalActions>
        </div>
      </Form>
    </Modal>
    """
  end
end
