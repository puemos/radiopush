defmodule Radiopush.Spotify.Client.SpotifyExImpl do
  @moduledoc false

  @behaviour Radiopush.Spotify.Client.Impl

  alias Radiopush.Spotify.Credentials

  @accounts_base_url "https://accounts.spotify.com"
  @api_base_url "https://api.spotify.com/v1"

  # User

  @impl true
  def get_profile(credentials) do
    with {:ok, details} <- request_with_refresh(credentials, :get, "/me") do
      {:ok,
       %{
         email: details["email"],
         display_name: details["display_name"],
         id: details["id"],
         images: Map.get(details, "images", [])
       }}
    end
  end

  @impl true
  def list_user_playlists(credentials) do
    with {:ok, details} <- request_with_refresh(credentials, :get, "/me/playlists") do
      {:ok, %{items: Map.get(details, "items", [])}}
    end
  end

  # Songs

  @impl true
  def get_song(credentials, song_id) do
    with {:ok, song} <- request_with_refresh(credentials, :get, "/tracks/#{song_id}") do
      {:ok,
       %{
         album: song["album"],
         artists: song["artists"],
         explicit: song["explicit"],
         id: song["id"],
         name: song["name"],
         preview_url: song["preview_url"],
         duration_ms: song["duration_ms"]
       }}
    end
  end

  @impl true
  def get_audio_features(credentials, song_id) do
    with {:ok, features} <- request_with_refresh(credentials, :get, "/audio-features/#{song_id}") do
      {:ok, %{tempo: features["tempo"] || 0.0}}
    end
  end

  defp request_with_refresh(%Credentials{} = credentials, method, path) do
    case request(credentials.access_token, method, path) do
      {:ok, payload} ->
        {:ok, payload}

      {:error, :unauthorized} ->
        with {:ok, refreshed} <- refresh(credentials),
             {:ok, payload} <- request(refreshed.access_token, method, path) do
          {:ok, payload}
        end

      {:error, _} = error ->
        error
    end
  end

  defp request(access_token, method, path) do
    case Req.request(
           method: method,
           url: @api_base_url <> path,
           auth: {:bearer, access_token},
           headers: [{"accept", "application/json"}]
         ) do
      {:ok, %Req.Response{status: status, body: body}} when status in 200..299 and is_map(body) ->
        {:ok, body}

      {:ok, %Req.Response{status: 401}} ->
        {:error, :unauthorized}

      {:ok, %Req.Response{body: %{"error" => %{"message" => message}}}} ->
        {:error, message}

      {:ok, %Req.Response{status: status}} ->
        {:error, "Spotify API request failed (#{status})"}

      {:error, _reason} ->
        {:error, "Timeout"}
    end
  end

  defp refresh(%Credentials{} = credentials) do
    {client_id, secret_key} = spotify_client_credentials!()
    basic = Base.encode64(client_id <> ":" <> secret_key)

    case Req.post(
           @accounts_base_url <> "/api/token",
           headers: [
             {"authorization", "Basic #{basic}"},
             {"content-type", "application/x-www-form-urlencoded"}
           ],
           form: [
             grant_type: "refresh_token",
             refresh_token: credentials.refresh_token
           ]
         ) do
      {:ok, %Req.Response{status: status, body: body}} when status in 200..299 and is_map(body) ->
        access_token = body["access_token"]
        refresh_token = body["refresh_token"] || credentials.refresh_token

        {:ok, Credentials.new(%{access_token: access_token, refresh_token: refresh_token})}

      {:ok, %Req.Response{body: %{"error_description" => message}}} ->
        {:error, message}

      {:ok, %Req.Response{body: %{"error" => message}}} when is_binary(message) ->
        {:error, message}

      {:ok, %Req.Response{status: status}} ->
        {:error, "Spotify auth failed (#{status})"}

      {:error, _reason} ->
        {:error, "Timeout"}
    end
  end

  defp spotify_client_credentials! do
    spotify = Application.get_env(:radiopush, :spotify, [])

    {Keyword.fetch!(spotify, :client_id), Keyword.fetch!(spotify, :secret_key)}
  end
end
