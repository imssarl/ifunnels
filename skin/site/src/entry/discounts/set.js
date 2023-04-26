import "!style-loader!css-loader!sass-loader!../../scss/discounts/index.scss";

(($) => {
  const checkboxNode = document.querySelectorAll(
    'input[type="checkbox"][data-type]'
  );

  $(".bootstrap-selectpicker").selectpicker();
  $(".autonumber").autoNumeric("init");

  checkboxNode.forEach((node) =>
    node.addEventListener("change", (e) => {
      const type = e.currentTarget.getAttribute("data-type");
      const block = document.querySelectorAll(`[data-block="${type}"]`);

      if (e.currentTarget.checked) {
        block.forEach((b) => b.classList.remove("hidden"));
      } else {
        block.forEach((b) => b.classList.add("hidden"));
      }
    })
  );
})(jQuery);
