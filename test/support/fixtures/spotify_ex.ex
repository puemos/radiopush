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

  def album() do
    %{
      album_type: "album",
      artists: [
        %{
          "external_urls" => %{
            "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
          },
          "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
          "id" => "70cRZdQywnSFp9pnc2WTCE",
          "name" => "Simon & Garfunkel",
          "type" => "artist",
          "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
        "BT",
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
      copyrights: [
        %{
          "text" =>
            "(P) Originally released 1970. All rights reserved by Columbia Records, a division of Sony Music Entertainment",
          "type" => "P"
        }
      ],
      external_ids: %{"upc" => "5099749521421"},
      external_urls: %{
        "spotify" => "https://open.spotify.com/album/0JwHz5SSvpYWuuCNbtYZoV"
      },
      genres: [],
      href: "https://api.spotify.com/v1/albums/0JwHz5SSvpYWuuCNbtYZoV",
      id: "0JwHz5SSvpYWuuCNbtYZoV",
      images: [
        %{
          "height" => 640,
          "url" => "https://i.scdn.co/image/ab67616d0000b273ba7fe7dd76cd4307e57dd75f",
          "width" => 640
        },
        %{
          "height" => 300,
          "url" => "https://i.scdn.co/image/ab67616d00001e02ba7fe7dd76cd4307e57dd75f",
          "width" => 300
        },
        %{
          "height" => 64,
          "url" => "https://i.scdn.co/image/ab67616d00004851ba7fe7dd76cd4307e57dd75f",
          "width" => 64
        }
      ],
      label: "Columbia",
      name: "Bridge Over Troubled Water",
      popularity: 78,
      release_date: "1970-01-26",
      release_date_precision: "day",
      tracks: %{
        cursors: nil,
        href: "https://api.spotify.com/v1/albums/0JwHz5SSvpYWuuCNbtYZoV/tracks?offset=0&limit=50",
        items: [
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BT",
              "BW",
              "BY",
              "BZ"
            ],
            disc_number: 1,
            duration_ms: 293_120,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/6l8EbYRtQMgKOyc1gcDHF9",
            id: "6l8EbYRtQMgKOyc1gcDHF9",
            is_playable: nil,
            linked_from: nil,
            name: "Bridge Over Troubled Water",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/235629aa4e2ef4c3c8cc623b348b646d31c26412?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 1,
            type: "track",
            uri: "spotify:track:6l8EbYRtQMgKOyc1gcDHF9"
          },
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BT",
              "BW",
              "BY"
            ],
            disc_number: 1,
            duration_ms: 187_040,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/1eN42Q7IWRzRBq8eW2Y2TE",
            id: "1eN42Q7IWRzRBq8eW2Y2TE",
            is_playable: nil,
            linked_from: nil,
            name: "El Condor Pasa (If I Could)",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/79b2999b58ff45557c0fd0a5dc0a771a18b788ef?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 2,
            type: "track",
            uri: "spotify:track:1eN42Q7IWRzRBq8eW2Y2TE"
          },
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BT",
              "BW"
            ],
            disc_number: 1,
            duration_ms: 174_826,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/6QhXQOpyYvbpdbyjgAqKdY",
            id: "6QhXQOpyYvbpdbyjgAqKdY",
            is_playable: nil,
            linked_from: nil,
            name: "Cecilia",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/e52bd8d14bd4e1850c7b8d8e65596e6eb47909ba?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 3,
            type: "track",
            uri: "spotify:track:6QhXQOpyYvbpdbyjgAqKdY"
          },
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BT"
            ],
            disc_number: 1,
            duration_ms: 155_373,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/4uIjNF84ZbteunNMxr4Xc0",
            id: "4uIjNF84ZbteunNMxr4Xc0",
            is_playable: nil,
            linked_from: nil,
            name: "Keep the Customer Satisfied",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/ac27c3257098b4c95ec826811a3f94dbb2bc2718?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 4,
            type: "track",
            uri: "spotify:track:4uIjNF84ZbteunNMxr4Xc0"
          },
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BS"
            ],
            disc_number: 1,
            duration_ms: 221_520,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/4zYloXZV6NwiwXenBTc9DI",
            id: "4zYloXZV6NwiwXenBTc9DI",
            is_playable: nil,
            linked_from: nil,
            name: "So Long, Frank Lloyd Wright",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/4ef821b231db8d21133f3e05adea8c44f5076e60?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 5,
            type: "track",
            uri: "spotify:track:4zYloXZV6NwiwXenBTc9DI"
          },
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BR"
            ],
            disc_number: 1,
            duration_ms: 308_520,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/76TZCvJ8GitQ2FA1q5dKu0",
            id: "76TZCvJ8GitQ2FA1q5dKu0",
            is_playable: nil,
            linked_from: nil,
            name: "The Boxer",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/ba833158dd80b316a9a108b1578fe1113b931132?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 6,
            type: "track",
            uri: "spotify:track:76TZCvJ8GitQ2FA1q5dKu0"
          },
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BO"
            ],
            disc_number: 1,
            duration_ms: 195_760,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/5Bh8l8evdBSIoaK6EP1bWI",
            id: "5Bh8l8evdBSIoaK6EP1bWI",
            is_playable: nil,
            linked_from: nil,
            name: "Baby Driver",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/2d2245168846af80c262d05028f0e1fdec26d5e7?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 7,
            type: "track",
            uri: "spotify:track:5Bh8l8evdBSIoaK6EP1bWI"
          },
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BN"
            ],
            disc_number: 1,
            duration_ms: 238_413,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/5MbXzXGbqobR8xPVPs8OXA",
            id: "5MbXzXGbqobR8xPVPs8OXA",
            is_playable: nil,
            linked_from: nil,
            name: "The Only Living Boy in New York",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/c1ed9f60bf3131e50eb5caffca982e6278f876b6?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 8,
            type: "track",
            uri: "spotify:track:5MbXzXGbqobR8xPVPs8OXA"
          },
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BJ"
            ],
            disc_number: 1,
            duration_ms: 166_173,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/0nNI8eyMjDGjPDuQq87aJb",
            id: "0nNI8eyMjDGjPDuQq87aJb",
            is_playable: nil,
            linked_from: nil,
            name: "Why Don't You Write Me",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/3f3b174c407933b503333b04417444968041091f?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 9,
            type: "track",
            uri: "spotify:track:0nNI8eyMjDGjPDuQq87aJb"
          },
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BI"
            ],
            disc_number: 1,
            duration_ms: 172_773,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/1tk4uuDWxk0DTx2X5rGSxe",
            id: "1tk4uuDWxk0DTx2X5rGSxe",
            is_playable: nil,
            linked_from: nil,
            name: "Bye Bye Love - Live at Memorial Auditorium, Burlington, VT - October 1968",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/497168179f972b81d8847031b2354cbdd043fc20?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 10,
            type: "track",
            uri: "spotify:track:1tk4uuDWxk0DTx2X5rGSxe"
          },
          %{
            album: nil,
            artists: [
              %{
                "external_urls" => %{
                  "spotify" => "https://open.spotify.com/artist/70cRZdQywnSFp9pnc2WTCE"
                },
                "href" => "https://api.spotify.com/v1/artists/70cRZdQywnSFp9pnc2WTCE",
                "id" => "70cRZdQywnSFp9pnc2WTCE",
                "name" => "Simon & Garfunkel",
                "type" => "artist",
                "uri" => "spotify:artist:70cRZdQywnSFp9pnc2WTCE"
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
              "BH"
            ],
            disc_number: 1,
            duration_ms: 110_653,
            explicit: false,
            external_ids: nil,
            href: "https://api.spotify.com/v1/tracks/5t9rkF7g7zIU1NFyrSJaQl",
            id: "5t9rkF7g7zIU1NFyrSJaQl",
            is_playable: nil,
            linked_from: nil,
            name: "Song for the Asking",
            popularity: nil,
            preview_url:
              "https://p.scdn.co/mp3-preview/f3432de39fdaa7151d389e33f20d8269f49385f4?cid=b1c32d1f01ec46528e1d9da3b7973e83",
            track_number: 11,
            type: "track",
            uri: "spotify:track:5t9rkF7g7zIU1NFyrSJaQl"
          }
        ],
        limit: 50,
        next: nil,
        offset: 0,
        previous: nil,
        total: 11
      },
      type: "album"
    }
  end
end
