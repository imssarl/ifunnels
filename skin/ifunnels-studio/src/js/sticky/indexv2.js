const sticks = [];

export default class Sticky {
  constructor(el) {
    const { height } = el.getBoundingClientRect();
    let flg_close = false;

    /** Close btn */
    const close = document.createElement("a");
    close.href = "#";
    close.classList.add("sticky-close");
    close.innerHTML = '<i class="zmdi zmdi-close"></i>';
    close.style = "display: none";

    el.appendChild(close);

    sticks.push({ el, height, close, flg_close });

    const item_index = sticks.length - 1;

    /** Event Click */
    close.addEventListener("click", (e) => {
      e.preventDefault();

      sticks[item_index].flg_close = true;
      el.classList.remove("sticky");
      e.currentTarget.style = "display: none";
    });
  }
}

window.addEventListener("scroll", () => {
  sticks.map(({ el, height, close, flg_close }) => {
    if (!flg_close && height + 100 <= window.scrollY) {
      el.classList.add("sticky");
      close.style = null;
    } else {
      el.classList.remove("sticky");
      close.style = "display: none";
    }
  });
});
