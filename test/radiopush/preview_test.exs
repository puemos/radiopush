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
               title: "Time Has Told Me",
               url: "https://music.apple.com/us/album/time-has-told-me/1440656068?i=1440656384"
             } = metadata
    end
  end
end
