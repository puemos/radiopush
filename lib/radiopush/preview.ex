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

  @spec get_embed(String.t()) :: String.t()
  def get_embed(url) do
    cond do
      String.contains?(url, "spotify.com") ->
        String.replace(url, "https://open.spotify.com", "https://open.spotify.com/embed")

      String.contains?(url, "apple.com") ->
        String.replace(url, "https://music.apple.com/", "https://embed.music.apple.com/")
    end
  end
end
