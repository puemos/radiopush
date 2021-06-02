defmodule Radiopush.Spotify.Song do
  @moduledoc false
  use TypedStruct

  typedstruct do
    field :type, atom()
    field :song, String.t()
    field :album, String.t()
    field :musician, String.t()
    field :url, String.t()
    field :image, String.t()
    field :audio_preview, String.t()
    field :explicit, boolean(), default: false
    field :duration_ms, non_neg_integer(), default: 0
  end

  def new(item) do
    %__MODULE__{
      type: item.type,
      song: item.song,
      album: item.album,
      musician: item.musician,
      url: item.url,
      image: item.image,
      audio_preview: item.audio_preview,
      explicit: item.explicit,
      duration_ms: item.duration_ms
    }
  end
end
