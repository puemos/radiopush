import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import { ClickOutside } from "./hooks/ClickOutside";
import { InfiniteScroll } from "./hooks/InfiniteScroll";
import { Notify } from "./hooks/Notify";
import { Play } from "./hooks/Play";
import { ScrollLock } from "./hooks/ScrollLock";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: {
    InfiniteScroll,
    Play,
    Notify,
    ClickOutside,
    ScrollLock,
  },
});

liveSocket.connect();

window.liveSocket = liveSocket;
