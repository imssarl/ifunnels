(($) => {
  const styleeditor = require("./styleeditor");
  const siteBuilder = require("./builder.js");
  const helper = require("../../helper");

  document.addEventListener("DOMContentLoaded", () => {
    $("#nftModal").on("shown.bs.modal", (e) => {
      const { element } = styleeditor.styleeditor.activeElement;
      const config_node = element.parentNode.querySelector(
        'script[data-type="config"][type="application/json"]'
      );
      let config = {};

      if (config_node) {
        config = { ...JSON.parse(config_node.innerText) };
      }

      Object.keys(config).forEach((name) => {
        const field = e.currentTarget.querySelector(`[name="${name}"]`);
        if (field) field.value = config[name];

        if (field.value == config[name] && field.type == "checkbox") {
          field.checked = true;
        }
      });

      $("#network").selectpicker("refresh");
    });

    document
      .getElementById("btnNftSettingSave")
      .addEventListener("click", (e) => {
        e.preventDefault();

        const { activeElement } = styleeditor.styleeditor;

        let config_node = activeElement.element.parentNode.querySelector(
          'script[data-type="config"][type="application/json"]'
        );

        if (!config_node) {
          const { parentFrame } = activeElement;
          config_node = parentFrame.contentDocument.createElement("script");

          config_node.setAttribute("type", "application/json");
          config_node.setAttribute("data-type", "config");

          activeElement.element.parentNode.appendChild(config_node);
        }

        config_node.innerText = JSON.stringify(
          helper.serializeArray(document.getElementById("nftModal"))
        );

        $("#nftModal").modal("hide");
        siteBuilder.site.setPendingChanges(true);
      });
  });
})(window.jQuery);
