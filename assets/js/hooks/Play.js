export const Play = {
  audio_preview() {
    return this.el.dataset.audio_preview;
  },
  post_id() {
    return this.el.dataset.post_id;
  },
  metadata() {
    return {
      title: this.el.dataset.title,
      artist: this.el.dataset.artist,
      album: this.el.dataset.album,
      artwork: this.el.dataset.artwork,
    };
  },
  play_status() {
    return this.el.dataset.play_status;
  },
  play() {
    if ("mediaSession" in navigator) {
      navigator.mediaSession.metadata = new MediaMetadata({
        title: this.metadata().title,
        artist: this.metadata().artist,
        album: this.metadata().album,
        artwork: [
          {
            src: this.metadata().artwork,
            type: "image/png",
            sizes: "635x635",
          },
        ],
      });
    }
    this.audio.play();
  },
  pause() {
    this.audio.pause();
  },
  mounted() {
    this.audio = new Audio(this.audio_preview());
    this.handleEvent("play", ({ id }) => {
      if (id === this.post_id()) {
        if (this.play_status() === "playing") {
          this.pause();
        }
        if (this.play_status() === "idle") {
          this.play();
        }
      } else {
        this.pause();
      }
    });

    this.audio.addEventListener("ended", () => {
      this.pushEventTo(`#${this.post_id()}`, "idle", {});
    });
    this.audio.addEventListener("pause", () => {
      this.pushEventTo(`#${this.post_id()}`, "idle", {});
    });
    this.audio.addEventListener("play", () => {
      this.pushEventTo(`#${this.post_id()}`, "playing", {});
    });
    this.audio.addEventListener("playing", () => {
      this.pushEventTo(`#${this.post_id()}`, "playing", {});
    });
  },
};
