defmodule Radiopush.Spotify.Impl do
  @moduledoc false

  alias Radiopush.Spotify.{Credentials, Song, Profile}

  @type error :: {:error, String.t()}

  @callback get_details_from_url(credentials :: Credentials.t(), url :: String.t()) ::
              {:ok, Song.t()} | error()

  @callback get_profile(credentials :: Credentials.t()) ::
              {:ok, Profile.t()} | error()

  @callback list_user_playlists(credentials :: Credentials.t()) ::
              {:ok, list(Playlist.t())} | error()
end
