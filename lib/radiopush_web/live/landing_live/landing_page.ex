defmodule RadiopushWeb.Pages.Landing do
  use RadiopushWeb, :live_view

  alias RadiopushWeb.Components.{
    Button,
    PostCard,
    Page
  }

  @impl true
  def render(assigns) do
    ~H"""
    <Page.render current_user={nil} path={@path}>
      <div class="flex flex-row justify-center">
        <div class="flex flex-col lg:flex-row py-4 max-w-7xl">
          <div class="mx-auto flex-1 lg:mr-4">
            <div class="relative z-10 lg:max-w-2xl lg:w-full">
              <div class="mx-auto sm:mt-12 sm:px-6 md:px-0">
                <div class="text-center lg:text-left">
                  <p class="block md:hidden text-4xl font-bold sp-underline primary text-white mb-4">Radiopush</p>
                  <h1 class="text-3xl text-gray-100 font-bold sm:text-5xl" style="line-height: 1.2">
                    <div class="">
                      Share and discover
                    </div>
                    <div class="">
                      songs, with
                      <span class="text-opacity-0 text-white bg-clip-text bg-gradient-to-tr from-yellow-300 to-spotify-600">
                        friends
                      </span>
                    </div>
                    <div class="">
                      <span class="text-opacity-0 text-white bg-clip-text bg-gradient-to-br from-emerald-300 to-indigo-500">
                        colleagues
                      </span>
                      and
                      <span class="text-opacity-0 text-white bg-clip-text bg-gradient-to-br from-pink-500 to-amber-300">
                        family
                      </span>
                    </div>
                  </h1>
                  <div class="mt-5 sm:mt-16 flex flex-col items-center justify-center lg:items-baseline lg:justify-start space-y-4">
                    <div class="flex flex-col sm:flex-row space-y-2 sm:space-y-0 sm:space-x-2">
                      <a href={Routes.user_authorization_path(@socket, :authorize, "spotify")}>
                        <Button.render class="px-6 bg-spotify-600">
                          <div class="flex flex-row items-center">
                            <img class="w-4 mr-2" src={Routes.static_path(@socket, "/images/Spotify_Icon_CMYK_White.png")}>
                            <span>Continue with Spotify</span>
                          </div>
                        </Button.render>
                      </a>
                      <a target="_blank" rel="noopener" href="https://github.com/puemos/radiopush">
                        <Button.render class="px-6 bg-gray-600">
                          <div class="flex flex-row items-center">
                            <img
                              class="w-4 mr-2"
                              src={Routes.static_path(@socket, "/images/GitHub-Mark-Light-120px-plus.png")}
                            />
                            <span>It's open-source!</span>
                          </div>
                        </Button.render>
                      </a>
                    </div>
                    <p class="w-full md:w-96">By continuing, you agree to Radiopush.app's <a class="underline hover:text-blue-400" href="/legal">Terms & Conditions</a> and <a class="underline hover:text-blue-400" href="/legal">Privacy Policy</a></p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="grid grid-cols-1 gap-2 pt-6">
            <div
              :for={{post, i} <- Enum.with_index(@posts)}
              class={"opacity-#{max(100 - i * 25, 0)} pointer-events-none"}
              style="touch-action: none;"
            >
              <.live_component
                module={PostCard}
                id={"post-#{post.id}"}
                nickname={post.user.nickname}
                post={post}
                channel={post.channel}
              />
            </div>
          </div>
          <div class="opacity-100 opacity-75 opacity-50 opacity-25 opacity-0" />
        </div>
      </div>
    </Page.render>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(path: "/")
      |> assign(posts: post_list())

    {:ok, socket}
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{
      path: path
    } = URI.parse(uri)

    socket =
      socket
      |> assign(path: path)

    {:noreply, socket}
  end

  defp post_list do
    [
      %{
        album: "Promised Heights",
        audio_preview:
          "https://p.scdn.co/mp3-preview/0e75013e02bdf85a94398a151e84d9b6527a10c9?cid=a46f5c5745a14fbf826186da8da5ecc3",
        channel_id: 13,
        id: 49,
        image: "https://i.scdn.co/image/ab67616d0000b27381e0b0ed33535779218597aa",
        inserted_at: DateTime.utc_now() |> DateTime.add(-6 * 60, :second),
        musician: "Cymande",
        song: "Brothers On The Slide",
        type: :song,
        updated_at: ~N[2021-03-14 09:33:58],
        url: "https://open.spotify.com/track/6cBhKpoE1GNqEtwqGScyBy",
        user_id: 12,
        explicit: false,
        tempo: 109.0,
        duration_ms: 251_000.0,
        user: %{
          nickname: "Dwight Schrute"
        },
        reactions: [
          %{emoji: "+1"},
          %{emoji: "+1"},
          %{emoji: "+1"},
          %{emoji: "boom"},
          %{emoji: "boom"},
          %{emoji: "clap"},
          %{emoji: "eyeglasses"}
        ],
        channel: %{
          id: "19bdfa7f-c05f-4d93-8c87-6a14ee50f5f2",
          inserted_at: ~U[2021-04-14 17:20:08.805210Z],
          name: "dunder_mifflin",
          private: false,
          updated_at: ~U[2021-04-14 20:14:21.566870Z]
        }
      },
      %{
        album: "Road to Knowhere",
        audio_preview:
          "https://p.scdn.co/mp3-preview/ec976bf3b66c527d011bc6329cf16669f0e236f8?cid=a46f5c5745a14fbf826186da8da5ecc3",
        channel_id: 13,
        id: 48,
        image: "https://i.scdn.co/image/ab67616d0000b273d81cf5ffa7eb516a55e71ea3",
        inserted_at: DateTime.utc_now() |> DateTime.add(-4 * 60 * 60, :second),
        musician: "Tommy Guerrero",
        song: "Highway Hustle",
        type: :song,
        updated_at: ~N[2021-03-14 09:33:37],
        url: "https://open.spotify.com/track/1rJaiv1oQkEL0DdBoKarPA",
        user_id: 12,
        explicit: false,
        tempo: 112.0,
        duration_ms: 214_000.0,
        user: %{
          nickname: "Erlich Bachman"
        },
        reactions: [
          %{emoji: "fire"},
          %{emoji: "fire"},
          %{emoji: "heart"},
          %{emoji: "joy"}
        ],
        channel: %{
          id: "19bdfa7f-c05f-4d93-8c87-6a14ee50f5f2",
          inserted_at: ~U[2021-04-14 17:20:08.805210Z],
          name: "piedpiper",
          private: false,
          updated_at: ~U[2021-04-14 20:14:21.566870Z]
        }
      },
      %{
        album: "Yort Savul: İSYAN MANİFESTOSU!",
        audio_preview:
          "https://p.scdn.co/mp3-preview/01769c207e6c28f7f5ef946338747d962b861331?cid=a46f5c5745a14fbf826186da8da5ecc3",
        channel_id: 13,
        id: 47,
        image: "https://i.scdn.co/image/ab67616d0000b273c0e9663d5838a26672d2741b",
        inserted_at: DateTime.utc_now() |> DateTime.add(-1 * 24 * 60 * 60, :second),
        musician: "Gaye Su Akyol",
        song: "İsyan Manifestosu",
        type: :song,
        updated_at: ~N[2021-03-14 09:33:12],
        url: "https://open.spotify.com/track/0jE2HYDc22ujaaXeWfgRx3",
        user_id: 12,
        explicit: false,
        tempo: 121.0,
        duration_ms: 286_000.0,
        user: %{
          nickname: "Gob Bluth"
        },
        reactions: [
          %{emoji: "tophat"},
          %{emoji: "dove"}
        ],
        channel: %{
          id: "19bdfa7f-c05f-4d93-8c87-6a14ee50f5f2",
          inserted_at: ~U[2021-04-14 17:20:08.805210Z],
          name: "TheBluths",
          private: false,
          updated_at: ~U[2021-04-14 20:14:21.566870Z]
        }
      },
      %{
        album: "In The Court Of The Crimson King",
        audio_preview:
          "https://p.scdn.co/mp3-preview/d1c5b380ab97183a19ca109b5aefe9b563d07e4d?cid=162b7dc01f3a4a2ca32ed3cec83d1e02",
        channel_id: 13,
        id: 46,
        image: "https://i.scdn.co/image/ab67616d0000b2730e36a62897cf3f5937bf9c16",
        inserted_at: DateTime.utc_now() |> DateTime.add(-5 * 24 * 60 * 60, :second),
        musician: "King Crimson",
        song: "I Talk To The Wind",
        type: :song,
        updated_at: ~N[2021-03-14 09:32:49],
        url: "https://open.spotify.com/track/4QbpagjMCqSECj6IimTL2n",
        user_id: 12,
        explicit: false,
        tempo: 80.0,
        duration_ms: 365_000.0,
        user: %{
          nickname: "Jimmy Conway"
        },
        reactions: [
          %{emoji: "+1"},
          %{emoji: "+1"}
        ],
        channel: %{
          id: "19bdfa7f-c05f-4d93-8c87-6a14ee50f5f2",
          inserted_at: ~U[2021-04-14 17:20:08.805210Z],
          name: "theGoodfellas",
          private: false,
          updated_at: ~U[2021-04-14 20:14:21.566870Z]
        }
      }
    ]
  end
end
