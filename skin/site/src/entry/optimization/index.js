import "../../scss/optimization/index.scss";
import axios from "axios";
import { serializeArray } from "../helper";

(function($) {
  let test_id = null;

  document.addEventListener("DOMContentLoaded", () => {
    const el = document.querySelectorAll("[data-test-name]");

    el.forEach((n) =>
      n.addEventListener("click", (e) => {
        e.currentTarget.parentNode.nextElementSibling.classList.toggle(
          "hidden"
        );
      })
    );

    const nodeDays = document.getElementById("days");
    const nodeVisitors = document.getElementById("visitors");
    const nodeAutoOptimize = document.getElementById("auto-optimize");
    const btnSaveSettings = document.getElementById("save_settings");
    const form = document.querySelector("#settings-modal form");
    const containerVariants = document.querySelector(
      "#settings-modal [data-variants]"
    );

    [nodeDays, nodeVisitors].map((n, i, a) =>
      n.addEventListener("change", () => {
        if (a.some((n) => n.value !== "0" && n.value !== "")) {
          nodeAutoOptimize.removeAttribute("disabled");
        } else {
          nodeAutoOptimize.setAttribute("disabled", true);
          nodeAutoOptimize.checked = false;
        }
      })
    );

    /** Settings Modal */
    $("#settings-modal").on("show.bs.modal", (e) => {
      form.querySelector(".alert").classList.add("hidden");
      test_id = e.relatedTarget.getAttribute("data-test");

      axios
        .post(
          ajaxURL,
          {
            action: "test_settings",
            data: { test_id },
          },
          { headers: { "Content-Type": "multipart/form-data" } }
        )
        .then((response) => {
          const { status, data } = response;

          if (status === 200) {
            nodeDays.value = data.days || "";
            nodeVisitors.value = data.visitors || "";

            if (
              (data.days != "0" && data.days != "") ||
              (data.visitors != "0" && data.visitors != "")
            ) {
              nodeAutoOptimize.removeAttribute("disabled");
            }

            if (data.auto_optimize == "1") {
              nodeAutoOptimize.checked = true;
            }

            containerVariants.innerHTML = ``;

            if (data.hasOwnProperty("access_options")) {
              data.access_options.forEach((v) => {
                containerVariants.innerHTML += `<div class="input-group m-b-5">
                  <span class="input-group-addon">${v}</span>
                  <input type="text" name="weight[${v}]" class="form-control" placeholder="Example: ${Math.round(
                  Math.random() * 100
                )}" value="${
                  data.weight &&
                  data.weight !== null &&
                  data.weight.hasOwnProperty(v)
                    ? data.weight[v]
                    : ""
                }">
                  <span class="input-group-addon">%</span>
                </div>`;
              });
            }
          }
        });
    });

    btnSaveSettings.addEventListener("click", (e) => {
      e.preventDefault();

      const data = { test_id };

      serializeArray(form).forEach((e) => {
        const match = e.name.match(/(\w+)\[([#,A-Z])\]/);

        if (match) {
          data[`${match[1]}`] = { ...data[`${match[1]}`], [match[2]]: e.value };
        } else {
          data[e.name] = e.value;
        }
      });

      axios
        .post(
          ajaxURL,
          { action: "save_settings", data },
          { headers: { "Content-Type": "multipart/form-data" } }
        )
        .then((response) => {
          const { status } = response;

          if (status === 200) {
            form.querySelector(".alert").classList.remove("hidden");
          }
        });
    });

    document.querySelectorAll("[data-crt]").forEach((el) => {
      el.addEventListener("click", (e) => {
        const spans = el
          .closest("table")
          .querySelectorAll(
            `tr>td:nth-child(${el.getAttribute("data-eq")})>span`
          );

        spans.forEach((span) => {
          if (!span.classList.contains("hidden")) {
            span.classList.add("hidden");
          } else {
            span.classList.remove("hidden");
          }
        });
      });
    });
  });
})(jQuery);
