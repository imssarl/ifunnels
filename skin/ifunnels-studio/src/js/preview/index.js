(() => {
  import(
    '!style-loader?{"attributes":{"class":"discount"}}!css-loader!sass-loader!../../scss/preview/index.scss'
  );

  const instance = {
    variants: [],
    style: null,
    selectedIndex: 0,
    testNodes: null,

    init: () => {
      instance.style = document.querySelector("style.test-ab");
      instance.getAllVariants().createPanel();
    },

    getAllVariants: () => {
      document
        .querySelectorAll("[data-variant-name]")
        .forEach((el) =>
          instance.variants.push(el.getAttribute("data-variant-name"))
        );

      instance.variants = [...new Set(instance.variants)].sort();

      return instance;
    },

    createPanel: () => {
      const { selectedIndex, variants } = instance;
      const node = document.createElement("div");
      let markup = ``;

      node.classList.add("test-ab-panel");
      node.innerHTML += `<div class="test-ab-header">Test A/B</div>`;

      markup += `<div class="test-ab-body">`;

      variants.map(
        (test, index) =>
          (markup += `<a href="${test}" class="${
            selectedIndex === index ? "active" : ""
          }">${test}</a>`)
      );

      node.innerHTML += markup;
      document.body.append(node);

      instance.testNodes = node.querySelectorAll("a");
      instance.testNodes.forEach((a, index) =>
        a.addEventListener("click", (e) => instance.setActive(e, index))
      );
    },

    setActive: (e, index) => {
      e.preventDefault() && e.stopPropagation();

      if (e.target.classList.contains("active")) {
        return false;
      }

      instance.selectedIndex = index;
      instance.testNodes.forEach((a) => a.classList.remove("active"));

      e.target.classList.add("active");

      instance.showVariant();

      console.log(index);

      console.log(e.target.getAttribute("href"));
    },

    showVariant: () => {
      const { variants, selectedIndex } = instance;
      instance.style.innerHTML = `[data-variant-current="${variants[selectedIndex]}"] [data-vhide-default],[data-variant-name]:not([data-variant-name="${variants[selectedIndex]}"]):not([data-vshow~="${variants[selectedIndex]}"]){display: none;}`;
    },
  };

  document.addEventListener("DOMContentLoaded", () => {
    instance.init();

    console.log(instance.variants);
  });
})();
