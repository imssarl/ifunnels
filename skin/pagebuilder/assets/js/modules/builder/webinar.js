(function () {
  const axios = require("axios");

  const webinar = {
    messages: [],

    table: document.getElementById("webinar-messages"),
    storeNode: null,

    init: (element, { parentFrame }) => {
      webinar.storeNode = element.querySelector(
        'script[type="application/json"]'
      );

      webinar.messages = [];

      if (!webinar.storeNode) {
        webinar.storeNode = parentFrame.contentWindow.document.createElement(
          "script"
        );
        webinar.storeNode.type = "application/json";
        element.appendChild(webinar.storeNode);
      }

      if (webinar.storeNode.innerText !== "") {
        webinar.parseJSON(webinar.storeNode.innerText);
      }

      $("#csv-file").on("change", (e) => {
        const data = new FormData();
        const [file] = e.currentTarget.files;

        if (!file) return;

        data.append("action", "csv");
        data.append("file", file);

        axios
          .post(dataURLs.ajax, data, {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          })
          .then(({ data }) =>
            data.map(([sec, username, message]) => ({
              sec,
              username,
              message,
            }))
          )
          .then((data) => webinar.messages = [...webinar.messages, ...data])
          .then(() => webinar.showMessages());
      });

      webinar.showMessages();
    },

    parseJSON: (json) => {
      webinar.messages = JSON.parse(json);
    },

    saveJSON: () => {
      webinar.storeNode.innerText = JSON.stringify(webinar.messages);
    },

    addMessage: (sec, username, message) => {
      webinar.messages.push({ sec, username, message });
      webinar.showMessages();
    },

    clearAllMessages: () => {
      webinar.messages = [];
      webinar.showMessages();
    },

    showMessages: () => {
      webinar.table.innerHTML = null;

      if (webinar.messages.length) {
        webinar.message = webinar.messages.sort((f, s) => {
          if (parseInt(f.sec) > parseInt(s.sec)) return 1;
          if (parseInt(f.sec) < parseInt(s.sec)) return -1;
          return 0;
        });

        webinar.messages.forEach(({ sec, username, message }, index) => {
          const node = document.createElement("tr");
          node.innerHTML = `<td>${sec}</td>
                    <td>${username}</td>
                    <td>${message}</td>
                    <td><i class="fa fa-trash text-danger" style="cursor: pointer; font-size: 18px"></i></td>`;

          webinar.table.appendChild(node);

          node.querySelector(".fa-trash").addEventListener("click", () => {
            webinar.messages.splice(index, 1);
            webinar.showMessages();
          });
        });
      } else {
        const node = document.createElement("tr");
        node.innerHTML = `<td colspan="4" align="center">Empty</td>`;
        webinar.table.appendChild(node);
      }
    },
  };

  module.exports = webinar;
})();
