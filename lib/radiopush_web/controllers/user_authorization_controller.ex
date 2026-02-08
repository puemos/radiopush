defmodule RadiopushWeb.UserAuthorizationController do
  use RadiopushWeb, :controller

  def authorize(conn, _params) do
    redirect(conn, external: Radiopush.Spotify.Auth.authorization_url())
  end
end
