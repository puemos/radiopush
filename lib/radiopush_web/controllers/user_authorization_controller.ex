defmodule RadiopushWeb.UserAuthorizationController do
  use RadiopushWeb, :controller

  def authorize(conn, _params) do
    redirect(conn, external: Spotify.Authorization.url())
  end
end
