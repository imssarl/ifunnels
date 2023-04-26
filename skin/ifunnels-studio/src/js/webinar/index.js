import "../../scss/webinar/index.scss";
import moment from "moment";

export default class Webinar {
  constructor() {
    this.webinarNode = null;
    this.webinarChat = null;
    this.data = null;

    this.webinarNode = document.querySelector('[data-component="chat"]');
    const { pathname, host } = window.location;

    if (
      this.webinarNode &&
      (["app.local", "app.ifunnels.com"].indexOf(host) == -1 ||
        pathname == "/ifunnels-studio/livepreview/")
    ) {
      this.init();
    }
  }

  static getInstance() {
    if (!window.webinarChat) {
      window.webinarChat = new Webinar();
    }

    return window.webinarChat;
  }

  init() {
    this.parseData();
    this.addMarkup();

    window.addEventListener(
      "message",
      ({ data, origin }) =>
        ["http://app.local", "https://app.ifunnels.com"].indexOf(origin) !=
          -1 && this.showFakeMessage(data)
    );
  }

  addStyles() {
    const link = document.createElement("link");
    link.type = "text/css";
    link.rel = "stylesheet";
    link.href = "//app.ifunnels.com/skin/ifunnels-studio/dist/css/webinar.bundle.css";
    document.head.appendChild(link);
  }

  parseData() {
    this.data = JSON.parse(this.webinarNode.querySelector('script[type="application/json"]').innerText);
  }

  addMarkup() {
    this.addStyles();

    const wrapper = document.createElement("div");
    wrapper.classList.add("webinar-wrapper");
    wrapper.innerHTML += `
      <div class="webinar-chat"></div>
      <div class="webinar-send">
        <input type="text" placeholder="Type your message..." />
        <button>Send</button>
      </div>`;

    this.webinarNode.appendChild(wrapper);
    this.webinarChat = this.webinarNode.querySelector(".webinar-chat");

    const input = this.webinarNode.querySelector("input");
    const button = this.webinarNode.querySelector("button");

    input.addEventListener("keyup", (e) => {
      if (e.keyCode == 13) {
        this.addMessage({ message: input.value }, true);
        input.value = null;
      }
    });

    button.addEventListener("click", (e) => {
      e.preventDefault();
      this.addMessage({ message: input.value }, true);
      input.value = null;
    });
  }

  addMessage({ message, username }, is_user = false) {
    if (!message.trim()) {
      return;
    }

    const node = document.createElement("div");
    node.classList.add("webinar-chat__message");

    const curren_time = moment().format("H:mm A");

    if (!is_user) {
      node.innerHTML = `<p class="webinar-chat__message__title">${username}, ${curren_time}</p>`;
      node.innerHTML += `<p class="webinar-chat__message__message">${message}</p>`;
    } else {
      node.classList.add("webinar-chat__message--right-side");
      node.innerHTML = `<p class="webinar-chat__message__title">You, ${curren_time}</p>`;
      node.innerHTML += `<p class="webinar-chat__message__message">${message}</p>`;
    }

    this.webinarChat.appendChild(node);
    this.webinarChat.scrollTop = this.webinarChat.scrollHeight;

    if (!is_user) {
      setTimeout(
        () => (this.webinarChat.scrollTop = this.webinarChat.scrollHeight),
        500
      );
    }
  }

  showFakeMessage(currentTime) {
    this.data = this.data.filter(({ sec }) => sec >= currentTime);
    this.data.forEach((message) => {
      if (parseInt(message.sec) <= currentTime) {
        this.addMessage(message);
      }
    });
  }
}

document.addEventListener(
  "DOMContentLoaded",
  () => (window.webinarChat = Webinar.getInstance())
);
