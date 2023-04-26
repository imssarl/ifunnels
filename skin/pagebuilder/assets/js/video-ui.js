(function () {
  "use strict";

  require('!style-loader?{"attributes":{"class":"vjs-styles"}}!css-loader!sass-loader!../sass/components/video.scss');

  const { default: videojs } = require("video.js");
  require("videojs-youtube");
  require("./vendor/videojs-vimeo.esm.js");

  window.cfg = {};

  const instance = {
    cfg: {
      videoSettings: {
        controls: true,
        preload: "auto",
        components: {},
        bigPlayButton: false,
        controlBar: true,
        errorDisplay: false,
        textTrackSettings: false,
        techOrder: ["html5", "youtube", "vimeo"],
      },
      player: null,
    },

    init: () => {
      instance.cfg.container = document.querySelector(".videoWrapper");
      instance.cfg.video = instance.cfg.container.querySelector("video");

      if (!instance.cfg.video) {
        return;
      }

      const source = instance.cfg.video.querySelector("source");
      const script = document.createElement("script");

      /** JSON */
      script.type = "application/json";

      script.innerText = JSON.stringify({
        src: source.getAttribute("src"),
        type: source.getAttribute("type"),
      });

      instance.cfg.container.insertBefore(
        script,
        instance.cfg.container.children[0]
      );

      instance.initVideoJS();
      window.cfg = instance.cfg;
    },

    initVideoJS() {
      const { video, videoSettings } = instance.cfg;

      instance.cfg.player = videojs(
        video,
        videoSettings,
        // eslint-disable-next-line func-names
        function () {
          // this.loadingSpinner.hide();
        }
      );
    },
  };

  document.addEventListener("DOMContentLoaded", instance.init());
})();
