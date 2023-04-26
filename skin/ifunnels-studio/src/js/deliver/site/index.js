import axios from "axios";
import Helper from "../../helper";
import FrolaEditor from "froala-editor";
import { loadStripe } from "@stripe/stripe-js";
import Payment from "../../protect/payment";

// import 'froala-editor/css/froala_style.min.css';

export default class Site {
  static init() {
    const _this = new Site();
    if (!!document.getElementById("btn-delete-logo")) {
      document
        .getElementById("btn-delete-logo")
        .addEventListener("click", (e) => {
          _this.deleteLogo(e);
        });
    }

    if (!!document.querySelector(".membership-form")) {
      const form = document.querySelector(".membership-form");
      const serialized = _this.serializeArray(form);

      if (form.querySelector('[name="arrData[frequency]"]').value == "1") {
        _this.parseRecurringPreviewForm(serialized);
      } else {
        _this.parseOneTimePreviewForm(serialized);
      }

      _this.bindActionField();
    }
  }

  /** Delete logo */
  async deleteLogo(e) {
    e.preventDefault();

    const { default: config } = await import("./config");
    const siteid = e.target.getAttribute("data-id");

    axios({
      method: "post",
      url: config.request.ajax,
      data: {
        siteid,
        action: "delete_logo",
      },
      headers: { "Content-Type": "multipart/form-data" },
    }).then(({ data }) => {
      if (data.hasOwnProperty("status") && data.status == "success") {
        const container = e.target.closest(".form-group");
        container.parentNode.removeChild(container);
      }
    });
  }

  bindActionField() {
    const form = document.querySelector(".membership-form");

    form.querySelectorAll("input, select").forEach((element) => {
      element.addEventListener("change", (e) => {
        if (e.currentTarget.getAttribute("name") != "period") {
          const serialized = this.serializeArray(form);

          if (form.querySelector('[name="arrData[frequency]"]').value == "1") {
            this.parseRecurringPreviewForm(serialized);
          } else {
            this.parseOneTimePreviewForm(serialized);
          }
        }
      });
    });

    form.getElementById("require_shipping").addEventListener("change", (e) => {
      form.querySelector(
        'select[name="arrData[allowed_contries][]"]'
      ).disabled = !e.target.checked;
      jQuery(".selectpicker").selectpicker("refresh");
    });
  }

  /*!
   * Serialize all form data into an array
   * (c) 2018 Chris Ferdinandi, MIT License, https://gomakethings.com
   * @param  {Node}   form The form to serialize
   * @return {String}      The serialized form data
   */
  serializeArray(form) {
    // Setup our serialized data
    const serialized = [];

    // Loop through each field in the form
    for (let i = 0; i < form.elements.length; i++) {
      const field = form.elements[i];

      // Don't serialize fields without a name, submits, buttons, file and reset inputs, and disabled fields
      if (
        !field.name ||
        field.disabled ||
        field.type === "file" ||
        field.type === "reset" ||
        field.type === "submit" ||
        field.type === "button"
      )
        continue;

      // If a multi-select, get all selections
      if (field.type === "select-multiple") {
        for (let n = 0; n < field.options.length; n++) {
          if (!field.options[n].selected) continue;
          serialized.push({
            name: field.name,
            value: field.options[n].value,
          });
        }
      }

      // Convert field data to a query string
      else if (
        (field.type !== "checkbox" && field.type !== "radio") ||
        field.checked
      ) {
        serialized.push({
          name: field.name,
          value: field.value,
        });
      }
    }

    return serialized;
  }

  parseRecurringPreviewForm(serializeArray) {
    const previewForm = document
      .querySelector("[data-form=subscription]")
      .cloneNode(true);

    previewForm.removeAttribute("data-form");
    previewForm.classList.add("subscription");

    const payment_form = previewForm.querySelector("#payment-form");

    /** Set default value */
    config.total_amount = 0;

    serializeArray.forEach((element) => {
      const field = previewForm.querySelectorAll(
        `[data-field="${element.name}"]`
      );

      if (!!field) {
        /** Title */
        if (element.name == "arrData[name]") {
          config.title = element.value || "";
        }

        /** Amount */
        if (element.name == "arrData[amount]") {
          config.total_amount += parseFloat(element.value || 0);
          config.amount = parseFloat(element.value || 0);
        }

        /** Add Charges */
        if (element.name == "arrData[add_charges]") {
          config.total_amount += parseFloat(element.value || 0);
          config.add_charges = parseFloat(element.value || 0);
        }

        if (element.name == "arrData[add_charges_frequency]") {
          config.add_charges_frequency = element.value || "";
        }

        /** Label Additional Charges */
        if (element.name == "arrData[label_charges]") {
          config.label_charges = element.value || "";
        }

        /** Add Taxes */
        if (element.name == "arrData[add_taxes]") {
          config.total_amount +=
            (config.total_amount * parseFloat(element.value || 0)) / 100;
          config.add_taxes = parseFloat(element.value || 0);
        }

        /** Frequency */
        if (element.name == "arrData[frequency]") {
          config.frequency = parseInt(element.value) || null;
        }

        /** Billing Freqiency */
        if (element.name == "arrData[billing_frequency]") {
          config.billing_frequency = element.value;
        }

        /** Trial Amount */
        if (element.name == "arrData[trial_amount]") {
          config.trial_amount = parseFloat(element.value || 0);

          if (element.value.trim().length) {
            config.trial = true;
          } else {
            config.trial = false;
          }
        }

        /** Trial Duration */
        if (element.name == "arrData[trial_duration]") {
          config.trial_duration = parseInt(element.value || 0);
        }

        /** Limit Rebills */
        if (element.name == "arrData[limit_rebills]") {
          config.limit_rebills = parseInt(element.value || 0);
        }
      }
    });

    this.outputDescription(payment_form, config.trial);
    document.getElementById("preview").childNodes[0].replaceWith(previewForm);
  }

  parseOneTimePreviewForm(serializeArray) {
    const previewForm = document
      .querySelector("[data-form=one_time]")
      .cloneNode(true);

    previewForm.removeAttribute("data-form");
    previewForm.classList.add("one-time");

    const payment_form = previewForm.querySelector("#payment-form");

    /** Set default value */
    config.total_amount = 0;

    serializeArray.forEach((element) => {
      const field = previewForm.querySelectorAll(
        `[data-field="${element.name}"]`
      );

      if (!!field) {
        /** Title */
        if (element.name == "arrData[name]") {
          config.title = element.value || "";
        }

        /** Amount */
        if (element.name == "arrData[amount]") {
          config.total_amount += parseFloat(element.value || 0);
          config.amount = parseFloat(element.value || 0);
        }

        /** Add Charges */
        if (element.name == "arrData[add_charges]") {
          config.total_amount += parseFloat(element.value || 0);
          config.add_charges = parseFloat(element.value || 0);
        }

        /** Label Additional Charges */
        if (element.name == "arrData[label_charges]") {
          config.label_charges = element.value || "";
        }

        /** Add Taxes */
        if (element.name == "arrData[add_taxes]") {
          config.total_amount +=
            (config.total_amount * parseFloat(element.value || 0)) / 100;
          config.add_taxes = parseFloat(element.value || 0);
        }

        /** Frequency */
        if (element.name == "arrData[frequency]") {
          config.frequency = parseInt(element.value) || null;
        }

        /** Limit Rebuils */
        if (element.name == "arrData[limit_rebills]") {
          config.limit_rebills = parseInt(element.value || 0);
        }

        config.trial = false;
        config.add_charges_frequency = null;
      }
    });

    this.outputDescription(payment_form, false);
    document.getElementById("preview").childNodes[0].replaceWith(previewForm);
  }

  async outputDescription(container, redraw_trial = true) {
    let firstChild = container.firstChild;
    const node = document.createElement("div");
    const order_summary = container.querySelector(".order-summary");
    let {
      logo,
      title,
      currency,
      amount,
      add_charges,
      label_charges,
      add_taxes,
      total_amount,
      trial,
      trial_amount,
      trial_duration,
      frequency,
      billing_frequency,
      add_charges_frequency,
      limit_rebills,
    } = config;

    if (order_summary) {
      container.removeChild(order_summary);
      firstChild = container.firstChild;
    }

    if (total_amount - Math.floor(total_amount) > 0) {
      total_amount = total_amount.toFixed(2);
    }

    container.insertBefore(node, firstChild);

    const btn = container.querySelector("button");
    if (btn) {
      btn.innerHTML = `Pay &nbsp;${Helper.getCode(currency)}${
        !trial ? total_amount : trial_amount
      }`;
    }

    if (frequency == 1) {
      if (add_charges && add_charges_frequency == "0") {
        total_amount = `${total_amount} (${Helper.getCode(
          currency
        )}${this.roundPrice(
          total_amount - add_charges
        )} / per ${billing_frequency})`;
      } else {
        if (frequency == "1") {
          total_amount = `${total_amount} / per ${billing_frequency}`;
        }
      }
    }

    let html = `<div class="order-summary">`;

    /** Logo */
    if (logo) {
      html += `<img class="lazyload" src="${logo}" />`;
    }

    /** Title */
    html += `<h3 class="form-subtitle">${title}</h3>`;

    /** Trial */
    if (trial) {
      html += `
				<div class="order-summary__choice">
					<input id="trial" type="radio" ${redraw_trial ? "checked" : ""} name="period" />
					<label for="trial">
						<span>
							Trial Period
							<span>${Helper.getCode(currency)}${trial_amount} for ${trial_duration}-day${
        [1, 0].indexOf(trial_duration % 10) === -1 || trial_duration == 11
          ? "s"
          : ""
      }</span>
						</span>
					</label>
					
					<input id="full" type="radio" name="period" ${!redraw_trial ? "checked" : ""} />
					<label for="full">
						<span>
							After Trial
							<span>${Helper.getCode(currency)}${total_amount}${
        limit_rebills
          ? " during " +
            limit_rebills +
            " " +
            billing_frequency +
            (limit_rebills % 10 !== 1 ? "s" : "")
          : ""
      }</span>
						</span>
					</label>
				</div>`;
    }

    /** Order Subtotal */
    html += `
			<div>
				<div class="order-summary__detail">
					<span>${!redraw_trial ? "Order Subtotal" : "Total Billed Today"}</span>
					<span></span>
					<span> ${Helper.getCode(currency)}${
      !redraw_trial ? amount : trial_amount
    }</span>
				</div>`;

    if (!redraw_trial) {
      /** Additional Charges */
      if (add_charges) {
        html += `
					<div class="order-summary__detail">
						<span>${label_charges ? label_charges : "Additional Charges"}${
          frequency && add_charges_frequency == "0" ? " (One Time)" : ""
        }</span>
						<span></span>
						<span>${Helper.getCode(currency)}${add_charges}</span>
					</div>`;
      }

      /** Add taxes */
      if (add_taxes) {
        html += `
					<div class="order-summary__detail">
						<span>Taxes</span>
						<span></span>
						<span>${add_taxes}%</span>
					</div>`;
      }
    }

    /** Total Amount */
    html += `
				<div class="order-summary__total-amount">
					<span>Total</span>
					<span>${Helper.getCode(currency)}${
      !redraw_trial ? total_amount : trial_amount
    }</span>
				</div>
			</div>
		</div>`;

    node.outerHTML = html;

    if (trial) {
      container
        .querySelector("input#full")
        .addEventListener("change", (e) =>
          this.outputDescription(container, false)
        );
      container
        .querySelector("input#trial")
        .addEventListener("change", (e) => this.outputDescription(container));
    }

    this.stripe = await loadStripe(config.publicKey, { stripeAccount: config.stripeAccount, apiVersion: '2020-03-02' });
    Payment.initCardField('#card-element', this.stripe);
  }

  roundPrice(value) {
    if (value - Math.floor(value) > 0) {
      value = value.toFixed(2);
    }

    return value;
  }
}
