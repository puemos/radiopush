defmodule RadiopushWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.Component, only: [assign_new: 3]

  alias Radiopush.Cmd.FetchOrCreateUser
  alias Radiopush.Context
  alias RadiopushWeb.Router.Helpers, as: Routes

  def assign_defaults(socket, session) do
    user = find_current_user(session)

    socket =
      socket
      |> assign_new(:context, fn ->
        Context.new(%{
          credentials: session["spotify_credentials"],
          user: user
        })
      end)

    case socket.assigns.context do
      %Context{credentials: _, user: _} ->
        socket

      _other ->
        socket
        |> put_flash(:error, "You must log in to access this page.")
        |> redirect(to: Routes.live_path(socket, RadiopushWeb.Pages.Landing))
    end
  end

  defp find_current_user(session) do
    with spotify_credentials when not is_nil(spotify_credentials) <-
           session["spotify_credentials"],
         {:ok, user} <-
           FetchOrCreateUser.run(%Context{}, %FetchOrCreateUser.Cmd{
             access_token: spotify_credentials.access_token,
             refresh_token: spotify_credentials.refresh_token
           }) do
      user
    end
  end

  @doc """
  Receives a validation tuple from a changeset and flatten the error message
  """
  def flatten_error_message({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
