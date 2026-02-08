defmodule Radiopush.Spotify.Auth do
  @moduledoc false

  import Plug.Conn

  alias Radiopush.Spotify.Credentials

  @accounts_base_url "https://accounts.spotify.com"

  def authorization_url do
    spotify = spotify_config()

    params =
      URI.encode_query(%{
        client_id: Keyword.fetch!(spotify, :client_id),
        response_type: "code",
        redirect_uri: Keyword.fetch!(spotify, :callback_url),
        scope: spotify |> Keyword.get(:scopes, []) |> Enum.join(" ")
      })

    @accounts_base_url <> "/authorize?" <> params
  end

  def authenticate(conn, %{"code" => code}) do
    case exchange_code_for_tokens(code) do
      {:ok, credentials} ->
        {:ok, put_private(conn, :spotify_credentials, credentials)}

      {:error, _reason} ->
        {:error, conn}
    end
  end

  def authenticate(conn, _params), do: {:error, conn}

  def refresh(conn), do: conn

  def credentials_from_conn(conn) do
    case conn.private[:spotify_credentials] do
      %Credentials{} = credentials ->
        credentials

      %{access_token: access_token, refresh_token: refresh_token} ->
        Credentials.new(%{access_token: access_token, refresh_token: refresh_token})

      _ ->
        nil
    end
  end

  defp exchange_code_for_tokens(code) do
    spotify = spotify_config()
    client_id = Keyword.fetch!(spotify, :client_id)
    secret_key = Keyword.fetch!(spotify, :secret_key)
    callback_url = Keyword.fetch!(spotify, :callback_url)

    basic = Base.encode64(client_id <> ":" <> secret_key)

    case Req.post(
           @accounts_base_url <> "/api/token",
           headers: [
             {"authorization", "Basic #{basic}"},
             {"content-type", "application/x-www-form-urlencoded"}
           ],
           form: [
             grant_type: "authorization_code",
             code: code,
             redirect_uri: callback_url
           ]
         ) do
      {:ok, %Req.Response{status: status, body: body}} when status in 200..299 and is_map(body) ->
        {:ok,
         Credentials.new(%{
           access_token: body["access_token"],
           refresh_token: body["refresh_token"]
         })}

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

  defp spotify_config do
    Application.get_env(:radiopush, :spotify, [])
  end
end
