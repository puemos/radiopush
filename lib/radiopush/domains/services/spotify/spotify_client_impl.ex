defmodule Radiopush.Spotify.SpotifyClientImpl do
  @moduledoc false

  alias Radiopush.Spotify.{Album, Song, Client, Credentials, Profile}

  @behaviour Radiopush.Spotify.Impl

  @impl true
  def list_user_playlists(%Credentials{} = credentials) do
    with {:ok, %{items: playlists}} <- Client.list_user_playlists(credentials) do
      {:ok, playlists}
    else
      {:error, error} -> {:error, error}
    end
  end

  @impl true
  def get_profile(%Credentials{} = credentials) do
    with {:ok, details} <- Client.get_profile(credentials) do
      %{
        email: email,
        display_name: nickname,
        id: id
      } = details

      %{"url" => image} = Enum.at(details.images, 0, %{"url" => ""})

      profile =
        Profile.new(%{
          email: email,
          nickname: nickname,
          image: image,
          id: id
        })

      {:ok, profile}
    else
      {:error, error} -> {:error, error}
    end
  end

  @impl true
  def get_details_from_url(%Credentials{} = credentials, url) do
    case get_id_from_url(url) do
      {:track, track_id} -> get_song(credentials, track_id)
      nil -> {:error, "InvalidURL"}
    end
  end

  # Albums

  defp get_album(credentials, album_id) do
    with {:ok, details} <- Client.get_album(credentials, album_id) do
      %{
        artists: [%{"name" => musician} | _],
        external_urls: %{"spotify" => url},
        images: [%{"url" => image} | _],
        name: name,
        tracks: %{items: [%{preview_url: audio_preview} | _]}
      } = details

      album =
        Album.new(%{
          type: :album,
          album: name,
          musician: musician,
          url: url,
          image: image,
          audio_preview: audio_preview
        })

      {:ok, album}
    else
      {:error, error} -> {:error, error}
    end
  end

  # Songs

  defp get_song(credentials, song_id) do
    with {:ok, details} <- Client.get_song(credentials, song_id) do
      %{
        album: %{
          "name" => album,
          "images" => [
            %{"url" => image}
            | _
          ]
        },
        artists: [%{"name" => musician} | _],
        id: id,
        name: name,
        preview_url: audio_preview
      } = details

      song =
        Song.new(%{
          type: :song,
          song: name,
          album: album,
          musician: musician,
          url: "https://open.spotify.com/track/#{id}",
          image: image,
          audio_preview: audio_preview
        })

      {:ok, song}
    else
      {:error, error} -> {:error, error}
    end
  end

  defp get_id_from_url(url) do
    case Regex.named_captures(~r/(.*)((album\/)(?<album>\w*)|(track\/)(?<track>\w*))/, url) do
      nil -> nil
      %{"album" => "", "track" => ""} -> nil
      %{"album" => album, "track" => ""} -> {:album, album}
      %{"album" => "", "track" => track} -> {:track, track}
    end
  end
end
