defmodule Radiopush.Spotify.SpotifyClientImpl do
  @moduledoc false

  alias Radiopush.Spotify.{Song, Client, Credentials, Profile}

  @behaviour Radiopush.Spotify.Impl

  @impl true
  def list_user_playlists(%Credentials{} = credentials) do
    case Client.list_user_playlists(credentials) do
      {:ok, %{items: playlists}} -> {:ok, playlists}
      {:error, error} -> {:error, error}
    end
  end

  @impl true
  def get_profile(%Credentials{} = credentials) do
    case Client.get_profile(credentials) do
      {:ok, details} ->
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

      {:error, error} ->
        {:error, error}
    end
  end

  @impl true
  def get_details_from_url(%Credentials{} = credentials, url) do
    case get_id_from_url(url) do
      {:track, track_id} -> get_song(credentials, track_id)
      nil -> {:error, "InvalidURL"}
    end
  end

  # Songs

  defp get_song(credentials, song_id) do
    with {:ok, song} <- Client.get_song(credentials, song_id),
         {:ok, features} <- Client.get_audio_features(credentials, song_id) do
      %{
        album: %{
          "name" => album,
          "images" => [
            %{"url" => image}
            | _
          ]
        },
        artists: [%{"name" => musician} | _],
        explicit: explicit,
        id: id,
        name: name,
        preview_url: audio_preview,
        duration_ms: duration_ms
      } = song

      %{tempo: tempo} = features

      song =
        Song.new(%{
          type: :song,
          song: name,
          album: album,
          musician: musician,
          url: "https://open.spotify.com/track/#{id}",
          image: image,
          audio_preview: audio_preview,
          explicit: explicit,
          tempo: tempo,
          duration_ms: duration_ms
        })

      {:ok, song}
    else
      {:error, error} ->
        {:error, error}
    end
  end

  defp get_id_from_url(url) do
    case Regex.named_captures(~r/(.*)(track\/)(?<track>\w*)/, url) do
      nil -> nil
      %{"track" => ""} -> nil
      %{"track" => track} -> {:track, track}
    end
  end
end
