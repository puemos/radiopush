defmodule Radiopush.Spotify do
  @moduledoc """
  The Spotify context.
  """
  @impl_module Application.compile_env(
                 :radiopush,
                 :spotify_service,
                 Radiopush.Spotify.SpotifyClientImpl
               )


  @behaviour Radiopush.Spotify.Impl

  defdelegate get_details_from_url(credentials, url), to: @impl_module
  defdelegate get_profile(credentials), to: @impl_module
  defdelegate list_user_playlists(credentials), to: @impl_module
end
