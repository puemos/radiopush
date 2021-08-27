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
    this.pushEventTo(`#${this.post_id()}`, "play", {});

    var playPromise = this.audio.play();

    playPromise.then(function () {
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
    })
  },
  pause() {
    this.audio.pause();
  },
  /*
  This function is called each time a component is added/updated.
  Meaning, there is n HTML audio, where n is the number of component
  */
  mounted() {
    this.audio = new Audio(this.audio_preview());
    this.handleEvent("play", ({ id }) => {
      if (id === this.post_id()) {
        if (this.play_status() === "playing") {
          this.pause();
        }
      } else {
        this.pause();
      }
    });

    // the play must be done inside a user interaction
    this.el.addEventListener("click", () => {
      this.play();
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
