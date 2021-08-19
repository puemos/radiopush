defmodule Radiopush.SpotifyExFixtures do
  def profile() do
    %{
      country: "SE",
      display_name: "JM Wizzler",
      email: "email@example.com",
      external_urls: %{
        "spotify" => "https://open.spotify.com/user/wizzler"
      },
      followers: %{
        "href" => nil,
        "total" => 3829
      },
      href: "https://api.spotify.com/v1/users/wizzler",
      id: "wizzler",
      images: [
        %{
          "height" => nil,
          "url" =>
            "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-frc3/t1.0-1/1970403_10152215092574354_1798272330_n.jpg",
          "width" => nil
        }
      ],
      product: "premium",
      type: "user",
      uri: "spotify:user:wizzler"
    }
  end

  def track() do
    %{
      album: %{
        "album_type" => "album",
        "artists" => [
          %{
            "external_urls" => %{
              "spotify" => "https://open.spotify.com/artist/0L8ExT028jH3ddEcZwqJJ5"
            },
            "href" => "https://api.spotify.com/v1/artists/0L8ExT028jH3ddEcZwqJJ5",
            "id" => "0L8ExT028jH3ddEcZwqJJ5",
            "name" => "Red Hot Chili Peppers",
            "type" => "artist",
            "uri" => "spotify:artist:0L8ExT028jH3ddEcZwqJJ5"
          }
        ],
        "available_markets" => [
          "AD",
          "AE",
          "AG",
          "AL",
          "AM",
          "AO",
          "AR",
          "AT",
          "AU",
          "AZ",
          "BA",
          "BB",
          "BD",
          "BE",
          "BF",
          "BG",
          "BH",
          "BI",
          "BJ",
          "BN",
          "BO",
          "BR",
          "BS",
          "BW",
          "BY",
          "BZ",
          "CA",
          "CH",
          "CI",
          "CL",
          "CM",
          "CO",
          "CR",
          "CV",
          "CW",
          "CY",
          "CZ",
          "DE",
          "DJ",
          "DK",
          "DM",
          "DO",
          "DZ",
          "EC",
          "EE",
          "EG"
        ],
        "external_urls" => %{
          "spotify" => "https://open.spotify.com/album/30Perjew8HyGkdSmqguYyg"
        },
        "href" => "https://api.spotify.com/v1/albums/30Perjew8HyGkdSmqguYyg",
        "id" => "30Perjew8HyGkdSmqguYyg",
        "images" => [
          %{
            "height" => 640,
            "url" => "https://i.scdn.co/image/ab67616d0000b273153d79816d853f2694b2cc70",
            "width" => 640
          },
          %{
            "height" => 300,
            "url" => "https://i.scdn.co/image/ab67616d00001e02153d79816d853f2694b2cc70",
            "width" => 300
          },
          %{
            "height" => 64,
            "url" => "https://i.scdn.co/image/ab67616d00004851153d79816d853f2694b2cc70",
            "width" => 64
          }
        ],
        "name" => "Blood Sugar Sex Magik (Deluxe Edition)",
        "release_date" => "1991-09-24",
        "release_date_precision" => "day",
        "total_tracks" => 19,
        "type" => "album",
        "uri" => "spotify:album:30Perjew8HyGkdSmqguYyg"
      },
      artists: [
        %{
          "external_urls" => %{
            "spotify" => "https://open.spotify.com/artist/0L8ExT028jH3ddEcZwqJJ5"
          },
          "href" => "https://api.spotify.com/v1/artists/0L8ExT028jH3ddEcZwqJJ5",
          "id" => "0L8ExT028jH3ddEcZwqJJ5",
          "name" => "Red Hot Chili Peppers",
          "type" => "artist",
          "uri" => "spotify:artist:0L8ExT028jH3ddEcZwqJJ5"
        }
      ],
      available_markets: [
        "AD",
        "AE",
        "AG",
        "AL",
        "AM",
        "AO",
        "AR",
        "AT",
        "AU",
        "AZ",
        "BA",
        "BB",
        "BD",
        "BE",
        "BF",
        "BG",
        "BH",
        "BI",
        "BJ",
        "BN",
        "BO",
        "BR",
        "BS",
        "BW",
        "BY",
        "BZ",
        "CA",
        "CH",
        "CI",
        "CL",
        "CM",
        "CO",
        "CR",
        "CV",
        "CW",
        "CY",
        "CZ",
        "DE",
        "DJ",
        "DK",
        "DM",
        "DO",
        "DZ",
        "EC",
        "EE",
        "EG",
        "ES"
      ],
      disc_number: 1,
      duration_ms: 216_693,
      explicit: true,
      external_ids: %{"isrc" => "USWB19901567"},
      href: "https://api.spotify.com/v1/tracks/2R6go62CuxqqX0w1TgXxes",
      id: "2R6go62CuxqqX0w1TgXxes",
      is_playable: nil,
      linked_from: nil,
      name: "If You Have to Ask",
      popularity: 58,
      preview_url:
        "https://p.scdn.co/mp3-preview/f3edb7d4c6cee1a5a544fa3271c2f63dd0e695cc?cid=b1c32d1f01ec46528e1d9da3b7973e83",
      track_number: 2,
      type: "track",
      uri: "spotify:track:2R6go62CuxqqX0w1TgXxes"
    }
  end

  def audio_features() do
    %{
      danceability: 0.709,
      energy: 0.738,
      key: 7,
      loudness: -12.019,
      mode: 1,
      speechiness: 0.048,
      acousticness: 0.00236,
      instrumentalness: 0.795,
      liveness: 0.073,
      valence: 0.671,
      type: "audio_features",
      id: "2R6go62CuxqqX0w1TgXxes",
      uri: "spotify:track:2R6go62CuxqqX0w1TgXxes",
      tempo: 96.24,
      track_href: "https://api.spotify.com/v1/tracks/2R6go62CuxqqX0w1TgXxes",
      analysis_url: "https://api.spotify.com/v1/audio-analysis/2R6go62CuxqqX0w1TgXxes",
      duration_ms: 216_693,
      time_signature: 4
    }
  end
end
