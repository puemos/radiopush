defmodule Radiopush.Spotify.Client do
  @moduledoc """
  The Spotify context.
  """

  @behaviour Radiopush.Spotify.Client.Impl

  # User

  @impl true
  def get_profile(credentials), do: client().get_profile(credentials)

  @impl true
  def list_user_playlists(credentials), do: client().list_user_playlists(credentials)

  # Songs

  @impl true
  def get_song(credentials, song_id), do: client().get_song(credentials, song_id)

  @impl true
  def get_audio_features(credentials, song_id), do: client().get_audio_features(credentials, song_id)

  defp client() do
    Application.get_env(:radiopush, :spotify_client, Radiopush.Spotify.Client.SpotifyExImpl)
  end
end
