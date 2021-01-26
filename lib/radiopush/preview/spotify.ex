defmodule Radiopush.Preview.Spotify do
  import Radiopush.Preview.Utils

  def parse(url) do
    case get_document(url) do
      {:ok, document} ->
        [type] = Floki.attribute(document, "[property='og:type']", "content")

        case type do
          "music.song" ->
            song(document)

          "music.album" ->
            album(document)

          _ ->
            {:error, "not supported"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def song(document) do
    [song_url] = Floki.attribute(document, "[property='og:url']", "content")
    [musician_url] = Floki.attribute(document, "[property='music:musician']", "content")
    [album_url] = Floki.attribute(document, "[property='music:album']", "content")

    with %{song: song, url: url, image: image} <- parse(:song, song_url),
         %{musician: musician} <- parse(:musician, musician_url),
         %{album: album} <- parse(:album, album_url) do
      %{
        type: "song",
        song: song,
        album: album,
        musician: musician,
        url: url,
        image: image
      }
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  def album(document) do
    [album_url] = Floki.attribute(document, "[property='og:url']", "content")
    [musician_url] = Floki.attribute(document, "[property='music:musician']", "content")

    with %{musician: musician} <- parse(:musician, musician_url),
         %{album: album, album_url: url, album_image: image} <- parse(:album, album_url) do
      %{
        type: "album",
        album: album,
        musician: musician,
        url: url,
        image: image
      }
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  def parse(:song, url) do
    case get_document(url) do
      {:ok, document} ->
        [song] = Floki.attribute(document, "[property='og:title']", "content")
        [image] = Floki.attribute(document, "[property='og:image']", "content")
        [url] = Floki.attribute(document, "[property='og:url']", "content")
        %{song: song, image: image, url: url}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def parse(:album, url) do
    case get_document(url) do
      {:ok, document} ->
        [album] = Floki.attribute(document, "[property='og:title']", "content")
        [album_image] = Floki.attribute(document, "[property='og:image']", "content")
        [album_url] = Floki.attribute(document, "[property='og:url']", "content")
        %{album: album, album_image: album_image, album_url: album_url}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def parse(:musician, url) do
    case get_document(url) do
      {:ok, document} ->
        [musician] = Floki.attribute(document, "[property='og:title']", "content")
        [musician_image] = Floki.attribute(document, "[property='og:image']", "content")
        [musician_url] = Floki.attribute(document, "[property='og:url']", "content")
        %{musician: musician, musician_image: musician_image, musician_url: musician_url}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
