defmodule RadiopushWeb.Components.NewChannelModal do
  use RadiopushWeb, :component

  alias RadiopushWeb.Components.{Button, Modal, ModalActions}

  attr :changeset, :any, required: true
  attr :submit, :string, required: true
  attr :close, :string, required: true

  def render(assigns) do
    assigns = assign(assigns, :form, to_form(assigns.changeset))

    ~H"""
    <Modal.render title="New channel">
      <form phx-submit={@submit} class="h-full">
        <div class="h-full flex flex-col">
          <div class="flex flex-row justify-between space-x-2">
            <div class="w-full">
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
              <input
                type="text"
                name={@form[:name].name}
                value={@form[:name].value}
                placeholder="Channel name"
                class="input w-full my-1"
              />
              <p :for={error <- @form[:name].errors} class="text-sm text-red-500">
                <%= flatten_error_message(error) %>
              </p>
            </div>
          </div>

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
          <ModalActions.render>
            <div class="flex flex-row w-full space-x-2">
              <Button.render click={@close} expand color="secondary">Close</Button.render>
              <Button.render type="submit" expand color="primary">Create</Button.render>
            </div>
          </ModalActions.render>
        </div>
      </form>
    </Modal.render>
    """
  end
end
