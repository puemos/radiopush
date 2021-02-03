defmodule Radiopush.PreviewTest do
  use Radiopush.DataCase
  use ExUnit.Case, async: true
  import Radiopush.PreviewFixtures
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  describe "preview" do
    alias Radiopush.Preview

    test "get_metadata/1 spotify song" do
      stub(HTTPoison.BaseMock, :get, fn url ->
        case url do
          "https://open.spotify.com/track/20FLGZPgMHXlU0VpQ0HpxN" ->
            {:ok, %{status_code: 200, body: spotify_song()}}

          "https://open.spotify.com/album/7IpcJbVxLLEfW0KXB7ndE2" ->
            {:ok, %{status_code: 200, body: spotify_album()}}

          "https://open.spotify.com/artist/5c3GLXai8YOMid29ZEuR9y" ->
            {:ok, %{status_code: 200, body: spotify_musician()}}
        end
      end)

      metadata = Preview.get_metadata("https://open.spotify.com/track/20FLGZPgMHXlU0VpQ0HpxN")

      assert %{
               type: "song",
               album: "Five Leaves Left",
               image: "https://i.scdn.co/image/ab67616d0000b273bd158c797b1026005c2917bc",
               musician: "Nick Drake",
               song: "Time Has Told Me",
               url: "https://open.spotify.com/track/20FLGZPgMHXlU0VpQ0HpxN"
             } = metadata
    end

    test "get_metadata/1 spotify album" do
      stub(HTTPoison.BaseMock, :get, fn url ->
        case url do
          "https://open.spotify.com/track/20FLGZPgMHXlU0VpQ0HpxN" ->
            {:ok, %{status_code: 200, body: spotify_song()}}

          "https://open.spotify.com/album/7IpcJbVxLLEfW0KXB7ndE2" ->
            {:ok, %{status_code: 200, body: spotify_album()}}

          "https://open.spotify.com/artist/5c3GLXai8YOMid29ZEuR9y" ->
            {:ok, %{status_code: 200, body: spotify_musician()}}
        end
      end)

      metadata = Preview.get_metadata("https://open.spotify.com/album/7IpcJbVxLLEfW0KXB7ndE2")

      assert %{
               image: "https://i.scdn.co/image/ab67616d0000b273bd158c797b1026005c2917bc",
               musician: "Nick Drake",
               album: "Five Leaves Left",
               type: "album",
               url: "https://open.spotify.com/album/7IpcJbVxLLEfW0KXB7ndE2"
             } = metadata
    end

    test "get_metadata/1 apple song" do
      stub(HTTPoison.BaseMock, :get, fn url ->
        case url do
          "https://music.apple.com/us/album/five-leaves-left-remastered/1440656068" ->
            {:ok, %{status_code: 200, body: apple_album()}}

          "https://music.apple.com/us/artist/nick-drake/1285818" ->
            {:ok, %{status_code: 200, body: apple_musician()}}

          "https://music.apple.com/us/album/time-has-told-me/1440656068?i=1440656384" ->
            {:ok, %{status_code: 200, body: apple_song()}}
        end
      end)

      metadata =
        Preview.get_metadata(
          "https://music.apple.com/us/album/time-has-told-me/1440656068?i=1440656384"
        )

      assert %{
               type: "song",
               album: "Five Leaves Left ((Remastered))",
               image:
                 "https://is3-ssl.mzstatic.com/image/thumb/Music128/v4/98/8d/65/988d652e-f112-2354-4880-6fecc35b8fa8/00042284291521.rgb.jpg/1200x630wp.png",
               musician: "Nick Drake",
               song: "Time Has Told Me",
               url: "https://music.apple.com/us/album/time-has-told-me/1440656068?i=1440656384"
             } = metadata
    end
  end
end
