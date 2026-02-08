defmodule RadiopushWeb.Components.PostCard do
  @moduledoc """
  Post card
  """
  use RadiopushWeb, :live_component

  alias RadiopushWeb.Components.{Card, EmojiPicker, Reaction}

  @impl true
  def mount(socket) do
    {:ok, assign(socket, open_emoji: false, play_status: :idle)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={"post-card-root-#{@id}"}>
      <Card.render>
        <div id={@id} class="flex flex-col p-1 h-full w-full">
          <div class="flex flex-row flex-wrap items-center mb-2 justify-start">
            <.link
              :if={@channel}
              class="text-sm font-bold text-gray-300 sp-underline primary hover:text-gray-100"
              navigate={"/c/#{@channel.name}"}
            >
              <%= @channel.name %>
            </.link>
            <div :if={@channel} class="text-gray-500 text-xs">&nbsp;•&nbsp;</div>
            <div class="text-gray-500 text-xs">Posted by @<%= @nickname %></div>
            <div class="text-gray-500 text-xs">&nbsp;•&nbsp;</div>
            <div class="text-gray-600 text-xs font-semibold" style="line-height: 17px;">
              <%= format_time(@post.inserted_at) %>
            </div>
          </div>

          <div class="flex flex-col justify-between w-full">
            <div class="flex flex-row w-full">
              <div class="w-20 h-20 md:w-32 md:h-32">
                <img src={@post.image} />
              </div>
              <div class="flex-1 flex flex-row justify-between">
                <div :if={@post.type == :song} class="flex-1 flex flex-col ml-3">
                  <a
                    target="_blank"
                    rel="noopener"
                    href={@post.url}
                    class="hover:text-primary-500 text-white font-semibold"
                  >
                    <div class="flex flex-row space-x-2 items-start">
                      <img class="w-4 h-4 mt-1" src="/images/Spotify_Icon_CMYK_White.png" />
                      <div><%= @post.song %></div>
                    </div>
                  </a>
                  <div class="font-normal">by <%= @post.musician %></div>
                  <div class="text-gray-500"><%= @post.album %></div>
                  <div class="mt-auto">
                    <span
                      :if={@post.explicit}
                      title="Explicit"
                      class="inline-flex justify-center items-center bg-gray-500 rounded-sm"
                    >
                      <span aria-label="Explicit" class="text-xs mx-1 text-black">E</span>
                    </span>
                    <span :if={@post.duration_ms != 0.0} class="text-xs text-gray-400"><%= format_duration(@post.duration_ms) %></span>
                    <span :if={@post.tempo != 0.0} class="text-xs text-gray-200 bg-gray-600 rounded-lg px-2"><%= format_tempo(@post.tempo) %></span>
                  </div>
                </div>
                <div class="flex flex-col ml-3">
                  <button
                    :if={@post.audio_preview}
                    phx-hook="Play"
                    id={"play-#{@id}"}
                    data-play_status={@play_status}
                    data-post_id={@id}
                    data-title={@post.song}
                    data-artist={@post.musician}
                    data-album={@post.album}
                    data-artwork={@post.image}
                    data-audio_preview={@post.audio_preview}
                    class="transition duration-400 ease-in-out shadow-xl transform hover:scale-110 w-12 h-12 flex justify-center items-center bg-gradient-to-br from-primary-600 to-secondary-600 text-white rounded-full focus:ring-0 focus:outline-none"
                  >
                    <svg
                      :if={@play_status == :idle}
                      class="w-10 h-10 ml-1"
                      width="512"
                      height="512"
                      viewBox="0 0 512 512"
                    >
                      <path d="M152.443 136.417l207.114 119.573-207.114 119.593z" fill="currentColor" />
                    </svg>
                    <svg
                      :if={@play_status == :playing}
                      class="w-10 h-10"
                      width="512"
                      height="512"
                      viewBox="0 0 512 512"
                    >
                      <path d="M162.642 148.337h56.034v215.317h-56.034v-215.316z" fill="currentColor" />
                      <path d="M293.356 148.337h56.002v215.317h-56.002v-215.316z" fill="currentColor" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>

            <div class="flex flex-row flex-wrap items-center mt-2 space-x-1 space-y-1">
              <button
                phx-click="open_emoji"
                phx-target={@myself}
                class="pointer h-8 w-8 p-1.5 text-sm bg-gray-700 relative rounded-full flex flex-row items-center justify-center shadow-xl focus:outline-none"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  class="h-full"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
              </button>
              <Reaction.render
                :for={{emoji, count} <- reaction_group(@post.reactions)}
                click="reaction_click"
                target={@myself}
                emoji={emoji}
                count={count}
              />
            </div>
            <div :if={@open_emoji} class="relative">
              <div
                class="absolute top-2 left-0 z-10"
                id={"emoji-picker-#{@id}"}
                phx-hook="ClickOutside"
                data-id={@id}
                data-event="click-outside-picker"
              >
                <.live_component module={EmojiPicker} click="emoji_click" target={@myself} id={"picker-#{@id}"} />
              </div>
            </div>
          </div>
        </div>
      </Card.render>
    </div>
    """
  end

  @impl true
  def handle_event("open_emoji", _params, socket) do
    {:noreply, assign_open_emoji(socket, !socket.assigns.open_emoji)}
  end

  @impl true
  def handle_event("click-outside-picker", _params, socket) do
    {:noreply, assign_open_emoji(socket, false)}
  end

  @impl true
  def handle_event("click-outside-play", _params, socket) do
    {:noreply, assign_open_emoji(socket, false)}
  end

  @impl true
  def handle_event("play", _params, socket) do
    {:noreply, push_event(socket, "play", %{id: socket.assigns.id})}
  end

  @impl true
  def handle_event("add_to_playlist", _params, socket) do
    post = socket.assigns.post

    event = %{
      event: "add_to_playlist",
      post_id: post.id
    }

    send(self(), event)

    {:noreply, socket}
  end

  @impl true
  def handle_event("reaction_click", %{"emoji" => emoji}, socket) do
    post = socket.assigns.post

    event = %{
      event: "delete_or_add_post_reaction",
      post_id: post.id,
      emoji: emoji
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

  @impl true
  def handle_event("playing", _params, socket) do
    {:noreply, assign_play_status(socket, :playing)}
  end

  @impl true
  def handle_event("idle", _params, socket) do
    {:noreply, assign_play_status(socket, :idle)}
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
    |> Enum.group_by(& &1.emoji)
    |> Enum.map(fn {emoji, values} -> {emoji, Enum.count(values)} end)
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

  defp format_duration(duration_ms) do
    duration = trunc(duration_ms)

    minutes = duration / 60_000
    seconds = rem(duration, 60_000) / 1000

    if seconds < 10 do
      "#{floor(minutes)}:0#{floor(seconds)}m"
    else
      "#{floor(minutes)}:#{floor(seconds)}m"
    end
  end

  defp format_tempo(tempo), do: "#{floor(tempo)} bpm"
end
