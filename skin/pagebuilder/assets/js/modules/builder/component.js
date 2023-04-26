(function () {
  const publisher = require("../../vendor/publisher");
  const { default: Tick } = require("@pqina/flip");
  const moment = require("moment");
  const _ = require("lodash");

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
          value: null,
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

  /** OnComponentDrop */
  publisher.subscribe("onComponentDrop", (block, e) => {
    e = e.get(0);

    if (e.getAttribute("data-component") === "countdown") {
      const { frameDocument } = block;

      // Stylesheet
      const stylesheet = frameDocument.createElement("link");
      stylesheet.rel = "stylesheet";
      stylesheet.href = "/skin/pagebuilder/assets/css/flip.css";

      frameDocument.head.appendChild(stylesheet);

      [
        {
          attr: "data-value",
          value: moment().format("YYYY-MM-DD HH-mm-ss"),
        },
        {
          attr: "data-delay",
          value: "1000",
        },
        {
          attr: "data-textcolor",
          value: "#595d63",
        },
        {
          attr: "data-labelcolor",
          value: "#3c3e3c",
        },
        {
          attr: "data-style",
          value: "days",
        },
        {
          attr: "data-type",
          value: "timer",
        },
        {
          attr: "data-labels",
          value: "show",
        },
      ].map(({ attr, value }) => e.setAttribute(attr, value));
      
      component.initCountdown(block);
    }
  });

  publisher.subscribe("onBlockLoaded", function (block) {
    const { frameDocument } = block;

    if (frameDocument.querySelector('[data-component="countdown"]') !== null) {
      component.initCountdown(block);
    }
  });

  const component = {
    initCountdown: async function ({ frameDocument }) {
      const countdown = frameDocument.querySelector(
        '[data-component="countdown"]'
      );

      // Clone config
      const cconfig = _.cloneDeep(config);

      // Clear
      countdown.innerHTML = null;

      const id = countdown.getAttribute("data-id");
      const style = countdown.getAttribute("data-style") || "months";
      const type = countdown.getAttribute("data-type") || "counter";
      const value = countdown.getAttribute("data-value");
      const lables = countdown.getAttribute("data-labels") || "hide";
      const delay = countdown.getAttribute("data-delay") || 1000;
      const direction = countdown.getAttribute("data-direction") || "down";
      const textColor = countdown.getAttribute("data-textcolor") || "#edebeb";
      const panelColor = countdown.getAttribute("data-panelcolor") || "#1d1c1c";
      const labelColor = countdown.getAttribute("data-labelcolor") || "#000";

      let tagStyle = frameDocument.querySelector(`style[data-id="${id}"]`);

      if (tagStyle === null) {
        tagStyle = frameDocument.createElement("style");
      }

      tagStyle.type = "text/css";
      tagStyle.setAttribute("data-id", id);
      tagStyle.innerHTML = `[data-id="${id}"] .tick-text-inline,[data-id="${id}"] .tick-label{color:${textColor}!important;}[data-id="${id}"] .tick-flip-panel{color:${textColor}!important;background-color:${panelColor}!important}[data-id="${id}"] .tick-text{color: ${labelColor}}`;
      countdown.after(tagStyle);

      cconfig.type.timercountdown[0].transform = cconfig.type.timer[0].transform = `preset(${cconfig.style[style]}) -> delay`;

      if (
        lables === "show" &&
        ["timercountdown", "timer"].indexOf(type) !== -1
      ) {
        cconfig.type[type][0].children[0].children = [
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
          {
            view: "text",
            key: "label",
          },
        ];
      }

      const tick = Tick.DOM.create({
        view: {
          children: cconfig.type[type],
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
            const counter = Tick.count.down(
              new Date(moment().add({ hour, minute, second }).valueOf()),
              {
                format: cconfig.style[style].split(",").map((e) => e.trim()),
              }
            );

            counter.onupdate = function (value) {
              tick.value = value;
            };
          }

          // Timer
          if (type == "timer") {
            const counter = Tick.count.down(new Date(moment(value).valueOf()), {
              format: cconfig.style[style].split(",").map((e) => e.trim()),
            });

            counter.onupdate = function (value) {
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
    },

    updateCountDown(block) {
      this.initCountdown(block).then(() =>
        setTimeout(() => block.heightAdjustment(), 1000)
      );
    },
  };

  module.exports.component = component;
})();
