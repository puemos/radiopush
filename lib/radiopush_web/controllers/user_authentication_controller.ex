defmodule RadiopushWeb.UserAuthenticationController do
  use RadiopushWeb, :controller
  alias Radiopush.Cmd.FetchOrCreateUser
  alias Radiopush.Context
  alias Radiopush.Spotify.Auth
  alias RadiopushWeb.UserAuth

  def authenticate(conn, params) do
    case Auth.authenticate(conn, params) do
      {:ok, conn} ->
        credentials = Auth.credentials_from_conn(conn)

        case FetchOrCreateUser.run(
               %Context{},
               %FetchOrCreateUser.Cmd{
                 access_token: credentials.access_token,
                 refresh_token: credentials.refresh_token
               }
             ) do
          {:ok, user} ->
            UserAuth.log_in_user(conn, user)

          _ ->
            conn
            |> put_flash(:error, "Authentication failed")
            |> redirect(to: "/")
        end

      {:error, conn} ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/")
    end
  end
end
