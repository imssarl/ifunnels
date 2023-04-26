import "../../scss/dashboard/index.scss";

import { pie, line } from "./charts";
import flatpickr from "flatpickr";
import axios from "axios";
import moment from "moment";
import Helper from "../helper";

const RANGE_DATE = 8;

class Dashboard {
  preloaderNode = null;
  last_subscribers = null;
  last_refunds = null;
  memberships = null;
  sales = null;
  member = null;
  lead = null;

  /** Inital method
   * @return void
   */
  static init() {
    const _this = new Dashboard();
    _this.preloaderNode = document.querySelector(".preloader-container");
    _this.last_subscribers = document.getElementById("last_subscribers");
    _this.last_refunds = document.getElementById("last_refunds");
    _this.last_rebills = document.getElementById("last_rebills");
    _this.memberships = document.getElementById("memberships");
    _this.sales = document.getElementById("sales");
    _this.member = document.getElementById("member");
    _this.lead = document.getElementById("lead");

    if (_this.preloaderNode) {
      _this.toggleLoader(true);
    }

    const datepicker = document.querySelectorAll("[data-filter='range_date']");

    document
      .querySelector('select[name="arrFilter[time]"]')
      .addEventListener("change", (e) => {
        if (e.currentTarget.value == RANGE_DATE) {
          datepicker.forEach((d) => d.classList.remove("hidden"));
        } else {
          datepicker.forEach((d) => d.classList.add("hidden"));
        }
      });

    /** Init datetime picker */
    flatpickr("#datepicker", { maxDate: "today" });
    flatpickr("#datepicker2", { maxDate: "today" });

    _this.getData();
  }

  /**
   * Receiving data from the server
   * @return void
   */
  getData() {
    axios
      .post(request_url, {
        action: "dashboard",
        data: { params },
      })
      .then(({ data, status }) => {
        if (status == 200) {
          this.toggleLoader(false);
          this.initCharts(data);

          this.initCounters({
            memberships: data.count.membership,
            sales: data.count.total_sales,
            currency: data.count.currency,
            member: data.count.member,
            lead: data.count.lead,
          });

          this.lastSubscribers({ data: data.arrConnections });
          this.lastRefunds({ data: data.arrRefunds });
          this.lastRebills({ data: data.arrRebills });
        }
      });
  }

  /** Init charts
   * @param [object]
   * @return void
   */
  initCharts({ count, diagramm, d_rebills }) {
    pie({
      ctx: "member_lead",
      title: "Memebers / Leads",
      data: [count.member, count.lead],
      backgroundColor: [window.chartColors.red, window.chartColors.blue],
      labels: ["Members", "Leads"],
    });

    line({
      ctx: "payments",
      title: "Payments",
      data: diagramm.data,
      backgroundColor: ["#99CAC0"],
      labels: diagramm.labels,
    });

    line({
      ctx: "rebills",
      title: "Rebills",
      data: d_rebills.data,
      backgroundColor: ["#069BFF"],
      labels: d_rebills.labels,
    });
  }

  /** Toggle loader
   * @param [boolean]
   * @return void
   */
  toggleLoader(enable) {
    this.preloaderNode.style.display = enable ? "flex" : "none";
  }

  /** Filling table the last 5 subscribers
   * @param [object]
   * @return void
   */
  lastSubscribers({ data }) {
    if (data.length) {
      const tbody = this.last_subscribers.querySelector("tbody");
      tbody.innerHTML = null;

      data.map(
        ({ email, type, name, added }, i) =>
          (tbody.innerHTML += `<tr>
            <td>${i + 1}</td>
            <td>${email}</td>
            <td><span class="label label-${
              type == "0" ? "primary" : "default"
            }">${name}</span></td>
            <td>${moment.unix(added).format("Y-MM-DD HH:mm:ss")}</td>    
        </tr>`)
      );
    }
  }

  /** Filling table the last 10 refunds
   * @param [object]
   * @return void
   */
  lastRefunds({ data }) {
    if (data.length) {
      const tbody = this.last_refunds.querySelector("tbody");
      tbody.innerHTML = null;

      data.map(
        ({ customer_email, type, membership, status }, i) =>
          (tbody.innerHTML += `<tr>
            <td>${i + 1}</td>
            <td>${customer_email}</td>
            <td><span class="label label-${
              type == "0" ? "primary" : "default"
            }">${membership}</span></td>
            <td><span class="label label-warning">${status}</span></td>
        </tr>`)
      );
    }
  }

  /** Filling table the last 10 rebills
   * @param [object]
   * @return void
   */
  lastRebills({ data }) {
    if (data.length) {
      const tbody = this.last_rebills.querySelector("tbody");
      tbody.innerHTML = null;

      data.map(
        ({ customer_email, amount, currency, type, membership, status }, i) => {
          let label_style = "inverse";

          switch (status) {
            case "active":
              label_style = "success";
              break;
            case "refunded":
              label_style = "warning";
              break;
            case "canceled":
              label_style = "danger";
              break;
            case "trialing":
              label_style = "primary";
              break;
          }

          tbody.innerHTML += `<tr>
              <td>${i + 1}</td>
              <td>${customer_email}</td>
              <td>${Helper.getCode(currency)}${Math.round(amount / 100, 2)}</td>
              <td><span class="label label-${label_style}">${status}</span></td>
          </tr>`;
        }
      );
    }
  }

  /** Add value to counter widgets
   * @param [object]
   * @return void
   */
  initCounters({ memberships, sales, currency, member, lead }) {
    this.memberships.innerHTML = memberships;
    this.sales.innerHTML = currency + sales;
    this.member.innerHTML = member;
    this.lead.innerHTML = lead;
  }
}

document.addEventListener("DOMContentLoaded", () => {
  Dashboard.init();
});
