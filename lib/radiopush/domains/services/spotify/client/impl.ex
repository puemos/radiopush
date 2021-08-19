defmodule Radiopush.Spotify.Client.Impl do
  @moduledoc false

  @type error :: {:error, String.t()}

  # User

  @callback get_profile(credentials :: map()) ::
              {:ok, map()} | error()

  @callback list_user_playlists(credentials :: map()) ::
              {:ok, list(map())} | error()

  # Songs

  @callback get_song(credentials :: map(), song_id :: String.t()) ::
              {:ok, map()} | error()

  @callback get_audio_features(credentials :: map(), song_id :: String.t()) ::
              {:ok, map()} | error()
end
