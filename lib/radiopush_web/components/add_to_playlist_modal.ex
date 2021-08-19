defmodule RadiopushWeb.Components.AddToPlaylistModal do
  use Surface.Component

  alias RadiopushWeb.Components.{
    Modal,
    ModalActions,
    Button
  }

  @doc "The post data"
  prop post, :map, required: true

  @doc "User's playlists"
  prop playlists, :list, default: []

  @doc "Event to close the modal"
  prop close, :event, required: true

  @doc "On playlist click"
  prop click_playlist, :event, required: true

  @impl true
  def render(assigns) do
    ~F"""
    <Modal title="Add to playlist">
      <div class="flex flex-col w-full">
        <div class="flex flex-col">
          <div :for={playlist <- @playlists} class="flex flex-row justify-between">
            <div>{playlist.name}</div>
            <Button click={@click_playlist} color="secondary" value={playlist.id}>Close</Button>
          </div>
        </div>
      </div>
      <ModalActions>
        <div class="flex flex-row w-full space-x-2">
          <Button click={@close} expand color="secondary">Close</Button>
        </div>
      </ModalActions>
    </Modal>
    """
  end
end
