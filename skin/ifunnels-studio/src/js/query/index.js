import URI from "urijs";

(() => {
  const uri = URI(window.location.href);
  const search = uri.search(true);

  document.addEventListener("DOMContentLoaded", () => {
    const _inputs = document.querySelectorAll('input[name="_inputRedirectTo"]');
    const _links = document.querySelectorAll('a:not([href^="#"])');

    // Input [_inputRedirectTo]
    if (_inputs.length) {
      _inputs.forEach((input) => {
        if (input.value.length) {
          input.value = URI(input.value)
            .addSearch(search)
            .toString();
        }
      });
    }

    // All link from page
    if (_links.length) {
      _links.forEach((a) =>
        a.setAttribute(
          "href",
          URI(a.getAttribute("href"))
            .addSearch(search)
            .toString()
        )
      );
    }
  });
})();
