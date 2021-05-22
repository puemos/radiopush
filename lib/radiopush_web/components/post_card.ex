defmodule RadiopushWeb.Components.PostCard do
  use Surface.LiveComponent

  alias Surface.Components.{
    LiveRedirect
  }

  alias RadiopushWeb.Components.{
    Reaction,
    Card,
    EmojiPicker
  }

  @doc "Nickname of the post author"
  prop nickname, :string, required: true

  @doc "The post data"
  prop post, :map, required: true

  @doc "The channel of the post data"
  prop channel, :map, required: true

  data open_emoji, :boolean, default: false
  data play_status, :atom, values: [:idle, :playing], default: :idle

  @impl true
  def render(assigns) do
    ~H"""
    <Card>
      <div id={{@id}} class="flex flex-col p-1 h-full w-full">
        <div class="flex flex-row flex-wrap items-center mb-2 justify-start">
          <LiveRedirect class="text-sm font-bold text-gray-300 sp-underline primary hover:text-gray-100" to="/c/{{@channel.name}}">
            {{"#{@channel.name}"}}
          </LiveRedirect>
          <div class="text-gray-500 text-xs">&nbsp;•&nbsp;</div>
          <div class="text-gray-500 text-xs">Posted by @{{@nickname}}</div>
          <div class="text-gray-500 text-xs">&nbsp;•&nbsp;</div>
          <div  class="text-gray-600 text-xs font-semibold"
                style="line-height: 17px;">
                {{format_time(@post.inserted_at)}}
          </div>
        </div>

        <div class="flex flex-col justify-between w-full">
          <div class="flex flex-row w-full">
            <div class="w-20 h-20 md:w-32 md:h-32">
              <img src="{{@post.image}}"/>
            </div>
            <div class="flex-1 flex flex-row justify-between">
              <div :if={{@post.type == :song}} class="flex-1 flex flex-col ml-3">
                <a target="_blank" rel="noopener" href={{@post.url}} class="hover:text-primary-500 text-white font-semibold">
                  <div class="flex flex-row space-x-2 items-start">
                    <img class="w-4 h-4 mt-1" src="/images/Spotify_Icon_CMYK_White.png"/>
                    <div>{{@post.song}}</div>
                  </div>
                </a>
                <div class="font-normal"> by {{@post.musician}}</div>
                <div class="text-gray-500">{{@post.album}}</div>
              </div>
              <div :if={{@post.type == :album}} class="flex-1 flex flex-col ml-3">
                <a target="_blank" rel="noopener" href={{@post.url}} class="hover:text-primary-500 text-white font-semibold">
                  <div class="flex flex-row space-x-2 items-start">
                    <img class="w-4 h-4 mt-1" src="/images/Spotify_Icon_CMYK_White.png"/>
                    <div>{{@post.album}}</div>
                  </div>
                </a>
                <div class="text-gray-500"> by {{@post.musician}}</div>
              </div>
              <div class="flex flex-col ml-3">
                <button :if={{@post.audio_preview}}
                        :on-click="play"
                        phx-hook="Play"
                        id={{"play-#{@id}"}}
                        data-play_status={{@play_status}}
                        data-post_id={{@id}}
                        data-title={{@post.song}}
                        data-artist={{@post.musician}}
                        data-album={{@post.album}}
                        data-artwork={{@post.image}}
                        data-audio_preview={{@post.audio_preview}}
                        class="transition duration-400 ease-in-out shadow-xl transform hover:scale-110 w-12 h-12 flex justify-center items-center bg-gradient-to-br from-primary-600 to-secondary-600 text-white rounded-full focus:ring-0 focus:outline-none">
                  <svg :if={{@play_status == :idle}} class="w-10 h-10 ml-1" width="512" height="512" viewBox="0 0 512 512">
                    <path d="M152.443 136.417l207.114 119.573-207.114 119.593z" fill="currentColor"/>
                  </svg>
                  <svg :if={{@play_status == :playing}} class="w-10 h-10" width="512" height="512" viewBox="0 0 512 512">
                    <path d="M162.642 148.337h56.034v215.317h-56.034v-215.316z" fill="currentColor"/>
                    <path d="M293.356 148.337h56.002v215.317h-56.002v-215.316z" fill="currentColor"/>
                  </svg>
                </button>
              </div>
            </div>
          </div>

          <div class="flex flex-row flex-wrap items-center mt-2 space-x-1 space-y-1">
            <button :on-click="open_emoji" class="pointer h-8 w-8 p-1.5 text-sm bg-gray-700 relative rounded-full flex flex-row items-center justify-center shadow-xl focus:outline-none">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </button>
            <Reaction :for={{ {emoji, count} <- reaction_group(@post.reactions)}} click="reaction_click" emoji={{emoji}} count={{count}} />
          </div>
          <div :if={{@open_emoji}} class="relative">
            <div class="absolute top-2 left-0 z-10" id={{"emoji-picker-#{@id}"}} phx-hook="ClickOutside" data-id={{@id}} data-event="click-outside-picker">
              <EmojiPicker click="emoji_click" id={{ "picker-#{@id}"}}  />
            </div>
          </div>
        </div>
      </div>
    </Card>
    """
  end

  def handle_event("open_emoji", _params, socket) do
    {:noreply, assign_open_emoji(socket, !socket.assigns.open_emoji)}
  end

  def handle_event("click-outside-picker", _params, socket) do
    {:noreply, assign_open_emoji(socket, false)}
  end

  def handle_event("click-outside-play", _params, socket) do
    {:noreply, assign_open_emoji(socket, false)}
  end

  def handle_event("play", _params, socket) do
    {:noreply, push_event(socket, "play", %{id: socket.assigns.id})}
  end

  def handle_event("add_to_playlist", _params, socket) do
    post = socket.assigns.post

    event = %{
      event: "add_to_playlist",
      post_id: post.id
    }

    send(self(), event)

    {:noreply, socket}
  end

  def handle_event("reaction_click", params, socket) do
    post = socket.assigns.post

    event = %{
      event: "delete_or_add_post_reaction",
      post_id: post.id,
      emoji: params["emoji"]
    }

    send(self(), event)

    {:noreply, socket}
  end

  @impl true
  def handle_event("emoji_click", %{"emoji" => emoji}, socket) do
    post = socket.assigns.post

    event = %{
      event: "delete_or_add_post_reaction",
      post_id: post.id,
      emoji: emoji
    }

    send(self(), event)

    {:noreply, assign_open_emoji(socket, false)}
  end

  def handle_event("playing", _params, socket) do
    socket =
      socket
      |> assign_play_status(:playing)

    {:noreply, socket}
  end

  def handle_event("idle", _params, socket) do
    socket =
      socket
      |> assign_play_status(:idle)

    {:noreply, socket}
  end

  defp assign_play_status(socket, status) do
    assign(socket, play_status: status)
  end

  defp assign_open_emoji(socket, open_emoji) do
    assign(socket, open_emoji: open_emoji)
  end

  defp reaction_group(reactions) when not is_list(reactions), do: []

  defp reaction_group(reactions) do
    reactions
    |> Enum.group_by(fn r -> r.emoji end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
  end

  defp format_time(inserted_at) do
    minute = 60
    hour = minute * 60
    day = hour * 24
    month = day * 30
    year = day * 356

    diff =
      DateTime.utc_now()
      |> DateTime.diff(inserted_at)

    cond do
      diff / year > 1 -> "#{floor(diff / year)}y"
      diff / month > 1 -> "#{floor(diff / month)}m"
      diff / day > 1 -> "#{floor(diff / day)}d"
      diff / hour > 1 -> "#{floor(diff / hour)}h"
      diff / minute > 1 -> "#{floor(diff / minute)}m"
      true -> "#{floor(diff)}s"
    end
  end
end
