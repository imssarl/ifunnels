(function () {
  "use strict";

  const notify = require("../shared/notify");
  const copy = require("copy-to-clipboard");
  const publisher = require("../../vendor/publisher");

  var pageSettings = {
    optimization_test: document.getElementById("optimization_test"),
    goal_lead: document.getElementById("goal_lead"),
    goal_registration: document.getElementById("goal_registration"),
    goal_sale: document.getElementById("goal_sale"),
    tracking_code_lead: document.getElementById("tracking_code_lead"),
    tracking_code_registration: document.getElementById(
      "tracking_code_registration"
    ),
    tracking_code_sale: document.getElementById("tracking_code_sale"),

    init: function () {
      if (
        ![
          this.optimization_test,
          this.goal_lead,
          this.goal_registration,
          this.goal_sale,
        ].every((e) => e)
      ) {
        return false;
      }

      $(this.optimization_test).on(
        "switchChange.bootstrapSwitch",
        this.activateOptimizationTest
      );

      [this.goal_lead, this.goal_registration, this.goal_sale].map((el) =>
        el.addEventListener("change", this.selectGoal.bind(this))
      );

      [
        this.tracking_code_lead,
        this.tracking_code_registration,
        this.tracking_code_sale,
      ].map((btn) =>
        btn.addEventListener("click", this.copyTrackCode.bind(this))
      );
    },

    activateOptimizationTest: function (e) {
      const el = document.querySelectorAll("[data-test]");

      if (el) {
        $(el).fadeToggle("fast");
      }
    },

    selectGoal: function (e) {
      e.preventDefault();

      const inputNode = e.currentTarget.parentNode.nextElementSibling;

      if (inputNode) {
        inputNode.style.display = e.currentTarget.checked ? "flex" : "none";
      }
    },

    copyTrackCode: function (e) {
      e.preventDefault();
      const { site } = require("./builder.js");
      const goal = e.currentTarget.getAttribute("data-goal");

      copy(
        `<script src="https://fasttrk.net/services/testab/track.js.php?pageid=${site.activePage.pageID}&goals_type=${goal}"></script>`
      );

      $.notify(
        "Copied",
        Object.assign(notify.config, {
          position: "top center",
          className: "warning",
        })
      );
    },
  };

  pageSettings.init();
})();
