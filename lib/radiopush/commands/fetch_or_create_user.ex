defmodule Radiopush.Cmd.FetchOrCreateUser do
  use TypedStruct

  typedstruct module: Cmd do
    field :access_token, String.t(), enforce: true
    field :refresh_token, String.t(), enforce: true
  end

  alias Radiopush.Context
  alias Radiopush.Accounts
  alias Radiopush.Spotify

  defp get_user_by_profile(profile) do
    case Accounts.get_user_by_spotify_id(profile.id) do
      {:ok, user} -> {:ok, user}
      {:error, _} -> Accounts.get_user_by_email(profile.email)
    end
  end

  @spec run(Radiopush.Context.t(), Radiopush.Cmd.FetchOrCreateUser.Cmd.t()) ::
          {:ok, map()} | {:error, binary()}
  def run(%Context{} = _ctx, %Cmd{} = cmd) do
    credentials =
      Spotify.Credentials.new(%{
        access_token: cmd.access_token,
        refresh_token: cmd.refresh_token
      })

    with {:ok, profile} <- Spotify.get_profile(credentials) do
      case get_user_by_profile(profile) do
        {:ok, user} ->
          Accounts.update_user(user, %{
            nickname: profile.nickname,
            image: profile.image,
            spotify_id: profile.id
          })

        {:error, _} ->
          Accounts.create_user(%{
            email: profile.email,
            nickname: profile.nickname,
            image: profile.image,
            spotify_id: profile.id
          })
      end
    else
      {:error, error} ->
        {:error, error}
    end
  end
end
