(function () {
  const alphabet = "#ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  let publisher = require("../../vendor/publisher");

  const variant = {
    canvasElement: null,
    element: null,
    flgEdit: false,
    currentVariant: null,

    /** DOM Elements */
    btn_test_save: document.getElementById("btn_test_save"),
    btn_toggle_save: document.getElementById("optimize_toggle_variant_save"),
    new_variant: document.getElementById("new_variant"),
    select_variant: document.getElementById("select_variant"),
    pageVariants: document.getElementById("pageVariants"),
    variantList: document.getElementById("variant_lists"),

    init: function () {
      this.btn_test_save.addEventListener("click", (e) => variant.saveTest(e));
      this.btn_toggle_save.addEventListener("click", (e) => this.saveToggle(e));

      publisher.subscribe("onBlockLoaded", (block) => {
        const siteBuilder = require("./builder.js");
        const { optimization_test } = siteBuilder.site.activePage.pageSettings;

        if (optimization_test.enable === "true") {
          setTimeout(() => this.collectionOfOptions(block), 3000);
        }
      });

      publisher.subscribe("onChangedStatus", (e) => {
        const { site } = require("./builder.js");

        if (e.checked) {
          site.activePage.blocks.map((block) =>
            this.collectionOfOptions(block)
          );

          this.toolbarVariants();
        } else {
          site.activePage.currentVariant = "#";
          this.pageVariants.innerHTML = "";
        }

        this.showBlockOnVariant();
      });

      publisher.subscribe("onChangeViewVariant", () => {
        const siteBuilder = require("./builder.js");

        const { blocks } = siteBuilder.site.activePage;
        blocks.forEach((b) => b.heightAdjustment());
      });

      publisher.subscribe("removeVariantFromCanvas", () => {
        variant.reloadVariants();
      });
    },

    /** Show modal with fields to create test */
    showCreateModal: function (flg_edit = false, e) {
      const siteBuilder = require("./builder.js");

      if (flg_edit && !e.target.classList.contains("current")) {
        e.target.parentNode
          .querySelectorAll("[data-variant]")
          .forEach((btn) => btn.classList.remove("current"));
        e.target.classList.add("current");

        const { element } = this;

        variant
          .showSelectedVariant(element, e.target.textContent)
          .then(() => publisher.publish("onChangeViewVariant"));
        return false;
      }

      /** Edit Modal */
      variant.flgEdit = flg_edit;

      variant.canvasElement = this;
      $("#optimize_create_block").modal("show");
      $("#select_variant").empty();

      if (flg_edit) {
        variant.currentVariant = e.currentTarget.getAttribute("data-variant");
      }

      const { variants } = siteBuilder.site.activePage;

      variants.map((value) => {
        const option = document.createElement("option");
        option.value = value;
        option.textContent = value === "#" ? "Create New" : value;

        if (flg_edit && variant.currentVariant == value) {
          option.selected = true;
        }

        select_variant.appendChild(option);
      });

      /** Refresh selectpicker */
      $(select_variant).selectpicker("refresh");
      new_variant.value = alphabet[variants.length];
    },

    /** Save new variant of test */
    saveTest: function (e) {
      e.preventDefault();
      const { parentBlock, element } = variant.canvasElement;
      const { styleeditor } = require("./styleeditor");
      const siteBuilder = require("./builder.js");

      if (variant.flgEdit) {
        const el = element.parentNode.querySelector(
          `${element.tagName.toLowerCase()}[data-variant-name="${
            variant.currentVariant
          }"][data-selector='${element.getAttribute("data-selector")}']`
        );

        if (el) {
          el.setAttribute("data-variant-name", this.select_variant.value);
        }
      } else {
        const clone = element.cloneNode(true);
        let new_variant = this.new_variant.value;

        if (this.select_variant.value !== "#") {
          new_variant = this.select_variant.value;
        }

        /** Add variant */
        this.addVariant(new_variant);

        if (!element.getAttribute("data-variant-name")) {
          element.setAttribute("data-variant-name", "#");
        }

        let dataid = element.getAttribute("data-id").split("_");
        dataid = dataid[0];

        element.parentNode
          .querySelectorAll(
            `${element.tagName.toLowerCase()}[data-variant-name][data-selector='${element.getAttribute(
              "data-selector"
            )}'][data-id^="${dataid}"]`
          )
          .forEach((n) => n.setAttribute("data-variant-show", false));

        clone.setAttribute("data-variant-name", new_variant);
        clone.setAttribute(
          "data-id",
          `${clone.getAttribute("data-id")}_${new_variant}`
        );
        clone.setAttribute("data-variant-show", true);
        clone.removeAttribute("data-vshow");
        clone.removeAttribute("data-vhide");
        clone.removeAttribute("data-vhide-default");

        element.after(clone);

        parentBlock.addStyleToVariant();
      }

      this.updateShowAttr(siteBuilder.site);

      /** Activate style editor mode */
      styleeditor.setupCanvasElements(parentBlock);
      siteBuilder.site.activePage.heightAdjustment();

      $("#optimize_create_block").modal("hide");

      this.flgEdit = false;

      siteBuilder.site.setPendingChanges(true);
    },

    addVariant: (variantName) => {
      const siteBuilder = require("./builder.js");

      if (!siteBuilder.site.activePage.variants.includes(variantName)) {
        siteBuilder.site.activePage.variants.push(variantName);

        variant.toolbarVariants();
      }
    },

    /** Build toolbar with variants of test */
    toolbarVariants: function () {
      const siteBuilder = require("./builder.js");
      const { pageSettings, variants, currentVariant } =
        siteBuilder.site.activePage;

      if (pageSettings.optimization_test.enable) {
        if (pageVariants.children.length) {
          [...pageVariants.children].forEach((element) =>
            pageVariants.removeChild(element)
          );
        }

        variants.sort().map((value) => {
          const btn = document.createElement("button");

          if (value === currentVariant) {
            btn.classList.add("active");
          }

          btn.setAttribute("data-variant", value);
          btn.innerText = value;
          pageVariants.append(btn);

          btn.addEventListener("click", this.changeVariant.bind(this));
        });
      }
    },

    /** Change variant of test */
    changeVariant: function (e) {
      e.preventDefault();
      const { site } = require("./builder.js");

      if (e.currentTarget.classList.contains("active")) {
        return false;
      }

      if (pageVariants.children.length) {
        [...pageVariants.children].forEach((element) =>
          element.classList.remove("active")
        );
      }

      e.currentTarget.classList.add("active");

      // Set current variant
      site.activePage.currentVariant = e.currentTarget.textContent;
      this.showBlockOnVariant();
    },

    /** Show blocks/elements with selected variant of test */
    showBlockOnVariant: function () {
      const siteBuilder = require("./builder.js");
      const { blocks } = siteBuilder.site.activePage;

      blocks.map((block) => block.variantView());
    },

    collectionOfOptions: function ({ frameDocument }) {
      // const siteBuilder = require("./builder.js");
      const nodeElements = frameDocument.querySelectorAll(
        "[data-variant-name]"
      );

      if (!nodeElements.length) {
        return;
      }

      [...nodeElements].map((v) =>
        this.addVariant(v.getAttribute("data-variant-name"))
      );

      this.showBlockOnVariant();
    },

    parseVariants: function (element) {
      const selector = element.getAttribute("data-selector");
      const tagName = element.tagName;
      let dataid = element.getAttribute("data-id").split("_");

      dataid = dataid[0];

      return [
        ...element.parentNode.querySelectorAll(
          `${tagName.toLowerCase()}[data-selector='${selector}'][data-variant-name][data-id^="${dataid}"]`
        ),
      ]
        .map((el) => ({
          active: !(getComputedStyle(el).display == "none"),
          name: el.getAttribute("data-variant-name"),
        }))
        .sort((a, b) => a.name.localeCompare(b.name));
    },

    showSelectedVariant: async function (el, variant) {
      const selector = el.getAttribute("data-selector");
      const tagName = el.tagName;

      let dataid = el.getAttribute("data-id").split("_");
      dataid = dataid[0];

      el.parentNode
        .querySelectorAll(
          `${tagName}[data-selector='${selector}'][data-variant-name][data-id^="${dataid}"]`
        )
        .forEach((e) => e.setAttribute("data-variant-show", false));

      el.parentNode
        .querySelector(
          `${tagName}[data-selector='${selector}'][data-variant-name="${variant}"][data-id^="${dataid}"]`
        )
        .setAttribute("data-variant-show", true);
    },

    updateShowAttr: function (site) {
      const { blocks } = site.activePage;
      blocks.map((b) => b.updateAttrShow());
    },

    toggleVisible: function () {
      $("#optimize_toggle_variant").modal("show");
      variant.element = this.element;

      const siteBuilder = require("./builder.js");
      let { variants } = siteBuilder.site.activePage;

      let dataid = this.element.getAttribute("data-id").split("_");
      dataid = dataid[0];

      const defaultElement = this.element.parentNode.querySelector(
        `${this.element.tagName.toLowerCase()}[data-selector='${this.element.getAttribute(
          "data-selector"
        )}'][data-id="${dataid}"]`
      );

      const vhide = defaultElement.getAttribute("data-vhide") || [];

      const addedVariants = [
        ...this.element.parentNode.querySelectorAll(
          `${this.element.tagName.toLowerCase()}[data-selector='${this.element.getAttribute(
            "data-selector"
          )}'][data-variant-name="#"]`
        ),
      ].map((e) => e.getAttribute("data-variant-name"));

      variant.variantList.innerHTML = "";
      variants = variants.filter((v) => !addedVariants.includes(v));

      if (!variants.includes("#")) {
        variants.push("#");
      }
      variants = variants.sort();

      /** Hide on variants */
      variants.forEach((v, i) => {
        // if (v === "#") return;

        const checkbox = document.createElement("div");
        checkbox.innerHTML = `<label class="checkbox" for="checkbox${i}">
            <input type="checkbox" value="${v}" id="checkbox${i}" data-toggle="checkbox" class="custom-checkbox" ${
          vhide.includes(v) ? 'checked="checked"' : ""
        }>
            <span class="icons">
              <span class="icon-unchecked"></span>
              <span class="icon-checked"></span>
            </span>
            ${v}
          </label>`;
        variant.variantList.appendChild(checkbox);
      });
    },

    saveToggle: function (e) {
      const siteBuilder = require("./builder.js");
      const vname = this.element.getAttribute("data-variant-name");
      let dataid = this.element.getAttribute("data-id").split("_");
      dataid = dataid[0];

      // Empty variant
      if (vname === null) {
        this.element.setAttribute("data-variant-name", "#");
      }
      // Not default variant
      else if (vname !== "#") {
        this.element = this.element.parentNode.querySelector(
          `${this.element.tagName.toLowerCase()}[data-selector='${this.element.getAttribute(
            "data-selector"
          )}'][data-variant-name="#"][data-id=${dataid}]`
        );
      }

      const vhide = [];
      this.variantList
        .querySelectorAll('input[type="checkbox"]')
        .forEach((c) => {
          if (c.checked) {
            vhide.push(c.value);
          }
        });

      /** Только для варинта #, скрытие его в # версии теста */
      if (vhide.includes("#")) {
        this.element.setAttribute("data-vhide-default", true);
      } else {
        this.element.removeAttribute("data-vhide-default");
      }

      this.element.setAttribute("data-vhide", vhide.join());

      $("#optimize_toggle_variant").modal("hide");
      this.element = null;

      this.updateShowAttr(siteBuilder.site);

      siteBuilder.site.setPendingChanges(true);
    },

    reloadVariants: function () {
      const siteBuilder = require("./builder.js");

      siteBuilder.site.activePage.variants = [];
      const { blocks } = siteBuilder.site.activePage;

      blocks.map(block => this.collectionOfOptions(block));

      siteBuilder.site.activePage.currentVariant = '#';
      this.showBlockOnVariant();

      siteBuilder.site.setPendingChanges(true);
    },
  };

  if ([variant.btn_test_save, variant.btn_toggle_save].every((n) => n)) {
    variant.init();
  }
  module.exports.variant = variant;
})();
