defmodule Radiopush.Qry.ListUserPlaylists do
  use TypedStruct

  typedstruct module: Query do
  end

  alias Radiopush.Context
  alias Radiopush.Spotify

  alias Radiopush.Spotify.{
    Playlist
  }

  defp filter_playlist(ctx) do
    fn playlist ->
      %{
        collaborative: collaborative,
        owner: %{"display_name" => display_name}
      } = playlist

      cond do
        collaborative -> true
        display_name == ctx.user.nickname -> true
        true -> false
      end
    end
  end

  defp map_playlist(playlist) do
    %{
      id: id,
      images: [%{"url" => image}],
      name: name,
      description: description,
      external_urls: %{
        "spotify" => uri
      }
    } = playlist

    Playlist.new(%{
      description: description,
      id: id,
      image: image,
      name: name,
      uri: uri
    })
  end

  def run(%Context{} = ctx, %Query{} = _qry) do
    with {:ok, playlists} <- Spotify.list_user_playlists(ctx.credentials) do
      playlists =
        playlists
        |> Enum.filter(filter_playlist(ctx))
        |> Enum.map(&map_playlist/1)

      {:ok, playlists}
    else
      {:error, error} ->
        {:error, error}

      {:ok, false} ->
        {:error, "Unauthorized"}
    end
  end
end
