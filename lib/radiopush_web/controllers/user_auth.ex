defmodule RadiopushWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Radiopush.Cmd.FetchOrCreateUser
  alias Radiopush.Context
  alias Radiopush.Spotify.Auth
  alias RadiopushWeb.Router.Helpers, as: Routes

  @doc """
  Logs the user in.
  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.
  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  def log_in_user(conn, _user, _params \\ %{}) do
    spotify_credentials = Auth.credentials_from_conn(conn)
    token = spotify_credentials.access_token
    user_return_to = get_session(conn, :user_return_to)

    conn
    |> renew_session()
    |> put_session(:spotify_credentials, spotify_credentials)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
    |> redirect(to: user_return_to || signed_in_path(conn))
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the user out.
  It clears all session data for safety. See renew_session.
  """
  def log_out_user(conn) do
    if live_socket_id = get_session(conn, :live_socket_id) do
      RadiopushWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> redirect(to: "/")
  end

  @doc """
  Authenticates the user by looking into the session
  and remember me token.
  """
  def fetch_current_user(conn, _opts) do
    with %{
           access_token: access_token,
           refresh_token: refresh_token
         } <- get_session(conn, :spotify_credentials),
         {:ok, user} <-
           FetchOrCreateUser.run(%Context{}, %FetchOrCreateUser.Cmd{
             access_token: access_token,
             refresh_token: refresh_token
           }) do
      assign(conn, :current_user, user)
    else
      _ -> assign(conn, :current_user, nil)
    end
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.
  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> maybe_store_return_to()
      |> redirect(to: Routes.live_path(conn, RadiopushWeb.Pages.Landing))
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(conn), do: Routes.live_path(conn, RadiopushWeb.Pages.Home)
end
