defmodule Radiopush.Preview do
  alias Radiopush.Preview.{Spotify, Apple}
  @spec get_metadata(String.t()) :: any
  def get_metadata(url) do
    cond do
      String.contains?(url, "spotify.com") ->
        Spotify.parse(url)

      String.contains?(url, "apple.com") ->
        Apple.parse(url)
    end
  end
end
