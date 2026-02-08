defmodule RadiopushWeb.Components.AddToPlaylistModal do
  use RadiopushWeb, :component

  alias RadiopushWeb.Components.{Button, Modal, ModalActions}

  attr :post, :map, required: true
  attr :playlists, :list, default: []
  attr :close, :string, required: true
  attr :click_playlist, :string, required: true

  def render(assigns) do
    ~H"""
    <Modal.render title="Add to playlist">
      <div class="flex flex-col w-full">
        <div class="flex flex-col">
          <div :for={playlist <- @playlists} class="flex flex-row justify-between">
            <div><%= playlist.name %></div>
            <Button.render click={@click_playlist} color="secondary" value={playlist.id}>Add</Button.render>
          </div>
        </div>
      </div>
      <ModalActions.render>
        <div class="flex flex-row w-full space-x-2">
          <Button.render click={@close} expand color="secondary">Close</Button.render>
        </div>
      </ModalActions.render>
    </Modal.render>
    """
  end
end
