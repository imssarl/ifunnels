import Helper from "../helper";
import Store from "../store";

import "../../scss/discount/index.scss";

export default class Discounts {
  /**
   * Создает список доступных скидок для пользователя
   *
   * @param {Node} node - Node контейнер для добавления списка
   */
  static generateDisCountBox(node) {
    const { discounts } = Store.buffer;
    const container = node.querySelector(".discount-box");

    container.innerHTML = `<div class="form-subtitle">${
      discounts.length == 1
        ? "Good news, you qualify for the following discount:"
        : "Good news! We've secured a few discounts for you! Pick the one you want!"
    }</div>`;

    discounts.forEach(({ name, discount_amount, discount_type, id }) => {
      container.innerHTML += `<div class="discount-item">
				<span class="discount-name">${name}</span> 
                <span class="discount-amount">
                    ${Helper.getDiscount(discount_type, discount_amount)}
                </span>
                <button class="discount-apply" data-discount="${id}"><i class="check circle outline icon"></i> Apply Now</button>
			</div>`;
    });

    const btns = container.querySelectorAll("button.discount-apply");

    btns.forEach((btn) =>
      btn.addEventListener("click", () => {
        Discounts.addDiscount(btn.getAttribute("data-discount"));
        btns.forEach((n) => n.setAttribute("disabled", "disabled"));
      })
    );
  }

  static addDiscount(discount_id) {
    Store.buffer.apply_discount = discount_id;
    console.log(discount_id, Store.buffer);

    document.dispatchEvent(
      new CustomEvent("applyDiscount", { detail: { discount_id } })
    );
  }
}
