import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "topbar";
import "../css/app.scss";
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

// Show progress bar on live navigation and form submits
topbar.config({
  barColors: { 0: "#7c3aed" },
  shadowColor: "rgba(0, 0, 0, .3)",
});
window.addEventListener("phx:page-loading-start", () => topbar.show());
window.addEventListener("phx:page-loading-stop", () => topbar.hide());

liveSocket.connect();

window.liveSocket = liveSocket;
