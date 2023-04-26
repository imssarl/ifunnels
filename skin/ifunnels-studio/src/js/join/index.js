import MicroModal from "micromodal";

let instanceJoin = null;

export default class JoinModal {
  cfg = {
    markup: `
        <div class="modal__overlay" tabindex="-1">
            <div class="modal__container" role="dialog" aria-modal="true" aria-labelledby="modal-1-title">
                <header class="modal__header">
                    <h2 class="modal__title" id="modal-1-title">
                        Your webinar is ready for you to join
                    </h2>
                </header>
            
                <main class="modal__content" id="modal-1-content">
                    <button disabled>Join Webinar</button>
                </main>
            </div>
        </div>`,
    modal_id: "join-to-webinar",

    node: {},
  };

  static getInstance(cfg = {}) {
    if (!instanceJoin) {
      instanceJoin = new JoinModal(cfg);
    }

    return instanceJoin;
  }

  constructor(cfg) {
    this.cfg.btn = cfg;
  }

  init() {
    const modal = document.createElement("div");

    modal.classList.add("modal", "micromodal-slide");
    modal.setAttribute("id", this.cfg.modal_id);
    modal.setAttribute("aria-hidden", "true");

    modal.innerHTML = this.cfg.markup;
    document.body.appendChild(modal);

    this.cfg.node.btn = document.querySelector(".modal button");
    this.cfg.node.btn.innerText = this.cfg.btn.text;
    this.cfg.node.btn.style.backgroundColor = this.cfg.btn.bColor;

    MicroModal.show(this.cfg.modal_id);
  }

  closeModal() {
    MicroModal.close(this.cfg.modal_id);
  }
}
