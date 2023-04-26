import videojs from "video.js";
import "videojs-youtube";
import "../vendor/videojs-vimeo.esm";

import "!style-loader!css-loader!sass-loader!../../scss/video/index.scss";
import JoinModal from "../join";
import Sticky from "../sticky/indexv2";

const instance = null;

class Video {
  timeOnSite = 0;
  interval = null;
  joinModal = null;

  constructor() {
    const { pathname, host } = window.location;

    if (
      ["app.local", "app.ifunnels.com"].indexOf(host) != -1 &&
      pathname != "/ifunnels-studio/livepreview/"
    ) {
      return;
    }

    this.init();
  }

  static getInstance() {
    return !instance ? new Video() : instance;
  }

  init() {
    const { hostname } = window.location;
    this.timeOnSite = parseInt(localStorage.getItem(hostname) || 0);
    const videoWrapper = document.querySelectorAll(".videoWrapper");

    this.video = Array.from(videoWrapper).map((video) => ({
      container: video.querySelector("div.video-container"),
      video: video.querySelector("video"),
      simulate_live: !video.getAttribute("data-sumulate-live")
        ? false
        : !(video.getAttribute("data-sumulate-live") === "false"),
      sticky: !video.getAttribute("data-sticky")
        ? false
        : !(video.getAttribute("data-sticky") === "false"),
      buttonText: video.getAttribute("data-button-text"),
      buttonColor: video.getAttribute("data-button-color"),
    }));

    this.video.map((video) => this.initVideoJS(video));
  }

  recordTime() {
    const { pathname, hostname } = window.location;

    if (
      ["app.local", "app.ifunnels.com"].indexOf(hostname) != -1 &&
      pathname !== "/ifunnels-studio/livepreview/"
    ) {
      return;
    }

    this.interval = setInterval(() => {
      this.timeOnSite++;
      localStorage.setItem(hostname, this.timeOnSite);

      if (window.webinarChat) {
        window.webinarChat.showFakeMessage(this.timeOnSite);
      }
    }, 1000);
  }

  play({ simulate_live, player }) {
    const { hostname } = window.location;

    if (simulate_live && player.duration() > this.timeOnSite) {
      player.currentTime(this.timeOnSite);
    } else {
      this.timeOnSite = 0;
      localStorage.setItem(hostname, 0);
    }

    player.play();
  }

  initVideoJS(obj) {
    const _this = this;
    const {
      simulate_live,
      video,
      container,
      sticky,
      buttonColor,
      buttonText,
    } = obj;

    const videoSettings = {
      controls: true,
      preload: "auto",
      components: {},
      bigPlayButton: false,
      controlBar: true,
      errorDisplay: false,
      textTrackSettings: false,
      techOrder: ["html5", "youtube", "vimeo"],
    };

    if (simulate_live) {
      videoSettings["controls"] = false;
      videoSettings["vimeo"] = {
        controls: false,
      };

      this.joinModal = JoinModal.getInstance({
        bColor: buttonColor,
        text: buttonText,
      });
      
      this.joinModal.init();

      const { cfg } = this.joinModal;
      cfg.node.btn.addEventListener("click", (e) => {
        e.preventDefault() && e.stopPropagation();

        this.play(obj);
        this.joinModal.closeModal();
      });
    } else {
      const [firstChild] = container.children;

      obj.play = document.createElement("div");
      obj.play.classList.add("video-player__play");

      container.insertBefore(obj.play, firstChild);

      obj.play.addEventListener("click", (e) => {
        e.preventDefault() && e.stopPropagation();
        obj.player.play();
        container.classList.add("video--started");
      });
    }

    if (sticky) {
      new Sticky(container);
    }

    obj.player = videojs(
      video,
      videoSettings,
      // eslint-disable-next-line func-names
      function() {
        // this.loadingSpinner.hide();
        simulate_live && _this.recordTime();

        if (simulate_live) {
          const { cfg } = _this.joinModal;

          this.one("loadedmetadata", () =>
            cfg.node.btn.removeAttribute("disabled")
          );
        }

        this.on("play", () => {
          obj.container.classList.add("video--started");
        });

        this.on("pause", () => {
          obj.container.classList.remove("video--started");
        });

        this.on("ended", () => {
          obj.container.classList.remove("video--started");
          clearInterval(_this.interval);
          this.timeOnSite = 0;
        });
      }
    );
  }
}

document.addEventListener("DOMContentLoaded", () => Video.getInstance());
