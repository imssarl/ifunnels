import "../../scss/sticky.scss";

(() => {
  const { pathname, host } = window.location;
  let flgClose = false;

  if (
    ["app.local", "app.ifunnels.com"].indexOf(host) != -1 &&
    pathname != "/ifunnels-studio/livepreview/"
  ) {
    return;
  }

  const video = document.querySelector('[data-sticky="true"]');

  if (!video) {
    return;
  }

  const { height } = video.getBoundingClientRect();

  /** Close btn */
  const close = document.createElement("a");
  close.href = "#";
  close.classList.add("sticky-close");
  close.innerHTML = '<i class="zmdi zmdi-close"></i>';
  close.style = 'display: none';

  video.parentNode.appendChild(close);

  /** Event Click */
  close.addEventListener("click", (e) => {
    e.preventDefault();
    flgClose = true;

    video.classList.remove("sticky");
    close.style = 'display: none';
  });

  window.addEventListener("scroll", () => {
    if (!flgClose && height + 100 <= window.scrollY) {
      video.classList.add("sticky");
      close.style = null;
    } else {
      video.classList.remove("sticky");
      close.style = 'display: none';
    }
  });
})();
