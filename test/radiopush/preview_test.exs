defmodule Radiopush.PreviewTest do
  use Radiopush.DataCase

  describe "preview" do
    alias Radiopush.Preview

    test "get_metadata/1 spotify song" do
      metadata = Preview.get_metadata("https://open.spotify.com/track/20FLGZPgMHXlU0VpQ0HpxN")

      assert %{
               type: "song",
               album: "Five Leaves Left",
               image: "https://i.scdn.co/image/ab67616d0000b273bd158c797b1026005c2917bc",
               musician: "Nick Drake",
               title: "Time Has Told Me",
               url: "https://open.spotify.com/track/20FLGZPgMHXlU0VpQ0HpxN"
             } = metadata
    end

    test "get_metadata/1 spotify album" do
      metadata = Preview.get_metadata("https://open.spotify.com/album/7IpcJbVxLLEfW0KXB7ndE2")

      assert %{
               image: "https://i.scdn.co/image/ab67616d0000b273bd158c797b1026005c2917bc",
               musician: "Nick Drake",
               title: "Five Leaves Left",
               type: "album",
               url: "https://open.spotify.com/album/7IpcJbVxLLEfW0KXB7ndE2"
             } = metadata
    end

    test "get_metadata/1 apple song" do
      metadata = Preview.get_metadata("https://music.apple.com/us/album/place-to-be/1440758653")

      assert %{
               type: "song",
               album: "Five Leaves Left",
               image:
                 "https://is3-ssl.mzstatic.com/image/thumb/Music128/v4/56/08/f3/5608f39a-6efc-a799-d4b8-b0da30acf1da/00042284292320.rgb.jpg/1200x630wp.png",
               musician: "Nick Drake",
               title: "Time Has Told Me",
               url: "https://music.apple.com/us/album/place-to-be/1440758653"
             } = metadata
    end
  end
end
