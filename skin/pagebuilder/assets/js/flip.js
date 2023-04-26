(function (d) {
  const { default: Tick } = require("@pqina/flip");
  const moment = require("moment");

  document.addEventListener("DOMContentLoaded", () => {
    const countdown = document.querySelector('[data-component="countdown"]');

    if (!countdown) return;

    // Clear
    countdown.innerHTML = null;

    const id = countdown.getAttribute("data-id");
    const style = countdown.getAttribute("data-style") || "months";
    const type = countdown.getAttribute("data-type") || "counter";
    const value = countdown.getAttribute("data-value");
    const lables = countdown.getAttribute("data-labels") || "hide";
    const delay = countdown.getAttribute("data-delay") || 1000;
    const direction = countdown.getAttribute("data-direction") || "down";
    const action = countdown.getAttribute("data-action") || "nothing";
    const url = countdown.getAttribute("data-url") || null;

    const config = {
      style: {
        months: "M, d, h, m, s",
        days: "d, h, m, s",
        days2: "d, h, m",
        hours: "h, m, s",
        minuts: "m, s",
      },

      type: {
        counter: [
          {
            root: "div",
            value: value,
            repeat: true,
            transform: "pad(0) -> split -> delay",
            children: [
              {
                view: "flip",
              },
            ],
          },
        ],

        bilboard: [
          {
            root: "div",
            layout: "horizontal fill",
            repeat: true,
            transform: "upper -> split -> delay(random, 100, 150)",
            children: [
              {
                view: "flip",
                transform: "ascii -> arrive -> round -> char(a-zA-Z)",
              },
            ],
          },
        ],

        timercountdown: [
          {
            repeat: true,
            layout: "horizontal fit",
            transform: "",
            children: [
              {
                layout: "group",
                root: "div",
                children: [
                  {
                    key: "value",
                    repeat: true,
                    transform: "pad(00) -> split -> delay",
                    root: "div",
                    children: [
                      {
                        view: "flip",
                      },
                    ],
                  },
                ],
              },
            ],
          },
        ],

        timer: [
          {
            repeat: true,
            layout: "horizontal fit",
            transform: "",
            children: [
              {
                layout: "group",
                root: "div",
                children: [
                  {
                    key: "value",
                    repeat: true,
                    transform: "pad(00) -> split -> delay",
                    root: "div",
                    children: [
                      {
                        view: "flip",
                      },
                    ],
                  },
                ],
              },
            ],
          },
        ],

        clock: [
          {
            layout: "horizontal fit",
            children: [
              {
                key: "hours",
                transform: "pad(00)",
                view: "flip",
              },
              {
                key: "sep",
                view: "text",
              },
              {
                key: "minutes",
                transform: "pad(00)",
                view: "flip",
              },
              {
                key: "sep",
                view: "text",
              },
              {
                key: "seconds",
                transform: "pad(00)",
                view: "flip",
              },
            ],
          },
        ],
      },
    };

    config.type.timercountdown[0].transform = config.type.timer[0].transform = `preset(${config.style[style]}) -> delay`;

    if (lables === "show" && ["timercountdown", "timer"].indexOf(type) !== -1) {
      config.type[type][0].children[0].children.push({
        view: "text",
        key: "label",
      });
    }

    const tick = Tick.DOM.create({
      view: {
        children: config.type[type],
      },

      didInit: function (tick) {
        // Counter
        if (type == "counter") {
          Tick.helper.duration(1, "seconds");
          tick.value = value;

          if (direction == "down") {
            tick.value = value;

            Tick.helper.interval(function () {
              tick.value--;
            }, parseInt(1000));
          }

          if (direction == "up") {
            Tick.helper.interval(function () {
              tick.value++;
            }, parseInt(delay));
          }
        }

        // Bilboard
        if (type == "bilboard") {
          var rotation = value.split(",");
          var index = 0;

          Tick.helper.interval(function () {
            tick.value = rotation[index];
            index = index < rotation.length - 1 ? index + 1 : 0;
          }, parseInt(delay));
        }

        // Timercountdown
        if (type == "timercountdown") {
          const [hour, minute, second] = value.split(":");
          let offset = localStorage.getItem("countdown-offset");

          if (offset === null) {
            offset = moment().add({ hour, minute, second }).valueOf();
            localStorage.setItem("countdown-offset", offset);
          } else {
            offset = parseInt(offset);
          }

          const counter = Tick.count.down(new Date(offset), {
            format: config.style[style].split(",").map((e) => e.trim()),
          });

          counter.onupdate = function (value) {
            if (value.every((v) => v === 0)) {
              if (action == "hide") {
                tick.destroy();
              }

              if (action == "redirect") {
                if (url) {
                  window.location.replace(url);
                }
              }

              if (action == "url") {
                if (url) {
                  window.location.replace(url);
                }
              }

              if (action == "reset") {
                offset = moment().add({ hour, minute, second }).valueOf();
                localStorage.setItem("countdown-offset", offset);
                window.location.reload();
              }
            }

            tick.value = value;
          };
        }

        // Timer
        if (type == "timer") {
          const counter = Tick.count.down(new Date(moment(value).valueOf()), {
            format: config.style[style].split(",").map((e) => e.trim()),
          });

          counter.onupdate = function (value) {
            if (value.every((v) => v === 0)) {
              if (action == "hide") {
                tick.destroy();
              }

              if (action == "redirect") {
                if (url) {
                  window.location.replace(url);
                }
              }

              if (action == "url") {
                if (url) {
                  window.location.replace(url);
                }
              }
            }

            tick.value = value;
          };
        }

        // Clock
        if (type == "clock") {
          Tick.helper.interval(function () {
            var d = Tick.helper.date();
            tick.value = {
              sep: ".",
              hours: d.getHours(),
              minutes: d.getMinutes(),
              seconds: d.getSeconds(),
            };
          });
        }
      },
    });

    countdown.appendChild(tick.root);
  });
})(document);
