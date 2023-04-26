const { styleeditor } = require("./styleeditor");

(() => {
  "use strict";

  const bump = {
    container: document.getElementById("bumpModal"),
    checkboxList: null,
    selectedMemberships: [],
    styleeditor: null,

    bumpSave: document.getElementById('btnBumpSave'),

    init: (styleeditor) => {

      bump.styleeditor = styleeditor;

      if (bump.container) {
        bump.checkboxList = bump.container.querySelectorAll(
          'input[name="membership[]"]'
        );
      } else {
        return false;
      }

      bump.checkboxList.forEach((element) =>
        element.addEventListener("change", bump.handlerChange)
      );

      /* Bump */
			bump.bumpSave.addEventListener('click', (e) => {
				bump.save(styleeditor.activeElement.element);
				$("#bumpModal").modal('hide');
			});

      $("#bumpModal").on("shown.bs.modal", bump.reset);
      $("#bumpModal").on("hide.bs.modal", bump.showCount);
    },

    handlerChange: ({ target: checkbox }) => {
      if (checkbox.checked) {
        bump.selectedMemberships.push(checkbox.value);
      } else {
        bump.selectedMemberships = bump.selectedMemberships.filter(
          (value) => value != checkbox.value
        );
      }

      if (bump.countChecked() == 3) {
        bump.disabledCheckbox();
      } else {
        bump.enableCheckbox();
      }
    },

    /**
     * Disabled checkbox if not checked
     */
    disabledCheckbox: () => {
      Array.from(bump.checkboxList)
        .filter((checkbox) => !checkbox.checked)
        .forEach((checkbox) => checkbox.setAttribute("disabled", true));
    },

    /**
     * Enabled all checkbox
     */
    enableCheckbox: () => {
      bump.checkboxList.forEach((checkbox) =>
        checkbox.removeAttribute("disabled")
      );
    },

    reset: () => {
      bump.selectedMemberships = JSON.parse(bump.styleeditor.activeElement.element.getAttribute("data-bump-list")) || [];

      console.log(bump.selectedMemberships);

      bump.checkboxList.forEach((checkbox) => {
        checkbox.checked = bump.selectedMemberships.indexOf(checkbox.value) !== -1;
        checkbox.removeAttribute("disabled");
      });

      if (bump.countChecked() == 3) {
        bump.disabledCheckbox();
      }
    },

    save: (element) => {
      element.setAttribute(
        "data-bump-list",
        JSON.stringify(bump.selectedMemberships)
      );
    },

    countChecked: () => bump.selectedMemberships.length,

    showCount: () => {
      document.querySelector(
        'a[href="#bumpModal"]'
      ).innerHTML = `<span class="label label-warning m-r-10">${bump.countChecked()}</span>Select Products`;
    },
  };

  module.exports = bump;
})();
