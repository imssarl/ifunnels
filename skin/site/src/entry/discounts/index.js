import URI from "urijs";

(async () => {
  const { path } = URI.parse(window.location.href);
  console.log(path);

  switch (path) {
    case "/deliver/discounts/":
      await import("./manage");
      break;

    case "/deliver/discounts/set/":
      await import("./set");
      break;
  }
})();

// (($) => {
//   document.addEventListener("DOMContentLoaded", () => {
//     const checkboxNode = document.querySelectorAll(
//       'input[type="checkbox"][data-type]'
//     );

//     $(".bootstrap-selectpicker").selectpicker();
//     $(".autonumber").autoNumeric("init");

//     checkboxNode.forEach((node) =>
//       node.addEventListener("change", (e) => {
//         const type = e.currentTarget.getAttribute("data-type");
//         const block = document.querySelectorAll(`[data-block="${type}"]`);

//         if (e.currentTarget.checked) {
//           block.forEach((b) => b.classList.remove("hidden"));
//         } else {
//           block.forEach((b) => b.classList.add("hidden"));
//         }
//       })
//     );

//     document.querySelectorAll('[data-btn="play"]').forEach((element) => {
//       element.addEventListener("click", (e) => {
//         e.preventDefault();

//         console.log(e);

//         axios
//           .post("", { id: element.getAttribute("data-id") })
//           .then((response) => {
//             console.log(response);
//           });
//       });
//     });
//   });
// })(jQuery);
