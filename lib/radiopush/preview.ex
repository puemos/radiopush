defmodule Radiopush.Preview do
  alias Radiopush.Preview.{Spotify, Apple}

  @type url_metadata :: %{
          type: binary(),
          song: binary() | nil,
          album: binary(),
          musician: binary(),
          url: binary(),
          image: binary()
        }

  @spec get_metadata(String.t()) :: url_metadata
  def get_metadata(url) do
    cond do
      String.contains?(url, "spotify.com") ->
        Spotify.parse(url)

      String.contains?(url, "apple.com") ->
        Apple.parse(url)
    end
  end
end
