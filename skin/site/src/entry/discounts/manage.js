import axios from "axios";
import Swal from "sweetalert2";
import "style-loader!css-loader!./index.scss";

(() => {
  document.querySelectorAll('[data-btn="play"]').forEach((element) => {
    element.addEventListener("click", (e) => {
      e.preventDefault();

      axios
        .post(ajaxUrl, {
          action: "discount_play",
          data: {
            id: element.getAttribute("data-id"),
          },
        })
        .then((response) => {
          const { data } = response;

          if (data.status) {
            const i = element.querySelector("i");

            if (i) {
              i.classList.toggle("ion-pause");
              i.classList.toggle("ion-play");
            }
          }
          console.log(response);
        });
    });
  });

  document.querySelectorAll(".reset").forEach((a) => {
    a.addEventListener("click", (e) => {
      e.preventDefault();

      Swal.fire({
        title: "Warning",
        showCancelButton: true,
        icon: "warning",
        text: "The DisCount campaign will be restarted from the current date",
        confirmButtonText: "Proceed",
        cancelButtonText: "Cancel",
        allowOutsideClick: false,
        allowEscapeKey: false,
      }).then((response) => {
        const { isConfirmed } = response;

        if (isConfirmed) {
          axios
            .post(ajaxUrl, {
              action: "discount_reset",
              data: {
                id: a.getAttribute("data-id"),
              },
            })
            .then((response) => {
              const { data } = response;

              if (data.status) {
                const i = a.parentNode.querySelector("i.ion-play");

                if (i) {
                  i.classList.toggle("ion-pause");
                  i.classList.toggle("ion-play");
                }
              }
            });
        }
      });
    });
  });
})();
