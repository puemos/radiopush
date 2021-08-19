defmodule Radiopush.Spotify.Client.SpotifyExImpl do
  @moduledoc false

  @behaviour Radiopush.Spotify.Client.Impl

  defp make_credentials(credentials) do
    %Spotify.Credentials{
      access_token: credentials.access_token,
      refresh_token: credentials.refresh_token
    }
  end

  defp run(fun, credentials, args \\ []) do
    credentials = make_credentials(credentials)

    case apply(fun, [credentials] ++ args) do
      {:ok, %{"error" => %{"message" => _, "status" => 401}}} ->
        case Spotify.Authentication.refresh(credentials) do
          {:ok, credentials} ->
            apply(fun, [credentials] ++ args)

          {:error, :timeout} ->
            {:error, "Timeout"}
        end

      {:ok, %{"error" => %{"message" => _, "status" => 400}}} ->
        {:error, "Unauthenticated"}

      {:ok, data} ->
        {:ok, data}
    end
  end

  # User

  @impl true
  def get_profile(credentials), do: run(&Spotify.Profile.me/1, credentials)

  @impl true
  def list_user_playlists(credentials),
    do: run(&Spotify.Playlist.get_current_user_playlists/1, credentials)

  # Songs

  @impl true
  def get_song(credentials, song_id),
    do: run(&Spotify.Track.get_track/2, credentials, [song_id])

  @impl true
  def get_audio_features(credentials, song_id),
    do: run(&Spotify.Track.audio_features/2, credentials, [song_id])
end
