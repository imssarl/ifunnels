require("!style-loader!css-loader!video.js/dist/video-js.css");
import videojs from "video.js";
import "videojs-youtube";
import "../vendor/videojs-vimeo.esm";
import URI from "urijs";

import "../../scss/video/index.scss";

class Video {
  videoTag = null;
  player = null;
  timeOnSite = 0;
  interval = null;
  isSimulate = false;

  constructor() {
    this.selectors = {
      container: document.querySelector(".video-container"),
      play: null,
      http_referer: document.querySelector('script[type="application/json"]')
        .innerText,
    };

    this.webinarChat = null;

    this.timeOnSite = parseInt(localStorage.getItem(this.selectors.http_referer) || 0);
    this.init();
  }

  static getInstance() {
    return new Video();
  }

  parseMediaType(url) {
    if (
      /(?:youtube(?:-nocookie)?\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/.test(
        url.toString()
      )
    ) {
      return "youtube";
    }

    if (/(?:player\.)?vimeo\.com\/(?:video\/)?([0-9]*)/.test(url.toString())) {
      return "vimeo";
    }

    return "mp4";
  }

  init() {
    this.videoTag = document.querySelector("video");

    const { query } = URI.parse(window.location.href);
    const { url, simulate_live } = URI.parseQuery(query);
    const media_type = this.parseMediaType(url);
    const source = document.createElement("source");

    this.isSimulate = simulate_live === "1";

    source.setAttribute("src", url);

    if (["youtube", "vimeo"].indexOf(media_type) > -1) {
      source.setAttribute("type", `video/${media_type}`);
    }

    this.videoTag.appendChild(source);

    this.initVideoJS();
    this.bindActions();
  }

  bindActions() {
    const { container } = this.selectors;
    const [firstChild] = container.children;

    this.selectors.play = document.createElement("div");
    this.selectors.play.classList.add("video-player__play");

    container.insertBefore(this.selectors.play, firstChild);

    this.selectors.play.addEventListener("click", (e) => {
      e.preventDefault() && e.stopPropagation();

      if (this.isSimulate && this.player.duration() > this.timeOnSite) {
        this.player.currentTime(this.timeOnSite);
      } else {
        this.timeOnSite = 0;
        localStorage.setItem(this.selectors.http_referer, 0);
      }

      this.player.play();
      container.classList.add("video--started");
    });
  }

  parseURI() {
    const { http_referer } = this.selectors;
    return URI.parse(http_referer);
  }

  recordTime() {
    const { path, hostname } = this.parseURI();

    if (
      ["app.local", "app.ifunnels.com"].indexOf(hostname) != -1 &&
      path !== "/ifunnels-studio/livepreview/"
    ) {
      return;
    }

    this.interval = setInterval(() => {
      this.timeOnSite++;
      localStorage.setItem(this.selectors.http_referer, this.timeOnSite);

      if (this.isSimulate) {
        window.parent.postMessage(this.timeOnSite, this.selectors.http_referer);
      }
    }, 1000);
  }

  initVideoJS() {
    const _this = this;

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

    if (this.isSimulate) {
      videoSettings["controls"] = false;
      videoSettings["vimeo"] = {
        controls: false,
      };
    }

    this.player = videojs(
      this.videoTag,
      videoSettings,
      // eslint-disable-next-line func-names
      function() {
        this.loadingSpinner.hide();
        _this.isSimulate && _this.recordTime();

        this.on("play", () => {
          _this.selectors.container.classList.add("video--started");
        });

        this.on("pause", () => {
          _this.selectors.container.classList.remove("video--started");
        });

        this.on("ended", () => {
          _this.selectors.container.classList.remove("video--started");
          clearInterval(_this.interval);
          this.timeOnSite = 0;
        });
      }
    );
  }
}

document.addEventListener("DOMContentLoaded", () => Video.getInstance());
