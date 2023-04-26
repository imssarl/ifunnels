(function () {
  "use strict";

  const Sticky = require("sticky-js");
  const stickyElements = document.querySelectorAll(".sticky");

  if (stickyElements.length) {
    const sticky = new Sticky(".sticky", { stickyClass: "sticked" });

    stickyElements.forEach((element) => {
      element.style.zIndex = 99999;
    });
  }
})();
