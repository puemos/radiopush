defmodule Radiopush.PreviewTest do
  use Radiopush.DataCase

  describe "preview" do
    alias Radiopush.Preview

    test "get_metadata/1 return link metadata" do
      url = "https://open.spotify.com/track/20FLGZPgMHXlU0VpQ0HpxN"
      metadata = Preview.get_metadata(url)

      assert %{
               artist: "Nick Drake",
               image: "https://i.scdn.co/image/ab67616d00001e02bd158c797b1026005c2917bc",
               link: url,
               title: "Time Has Told Me"
             } = metadata
    end
  end
end
