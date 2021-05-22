defmodule RadiopushWeb.UserSessionController do
  use RadiopushWeb, :controller

  alias RadiopushWeb.UserAuth

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end
