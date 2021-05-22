defmodule Radiopush.Spotify.Playlist do
  @moduledoc false
  use TypedStruct

  typedstruct do
    field :description, String.t()
    field :id, String.t()
    field :image, String.t()
    field :name, String.t()
    field :uri, String.t()
  end

  @spec new(%{
          :description => any,
          :id => any,
          :image => any,
          :name => any,
          :uri => any
        }) :: Radiopush.Spotify.Playlist.t()
  def new(item) do
    %__MODULE__{
      description: item.description,
      id: item.id,
      image: item.image,
      name: item.name,
      uri: item.uri
    }
  end
end
