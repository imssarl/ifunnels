import Swal from "sweetalert2";
import "../../scss/domains/index.scss";
import Axios from "axios";

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".confirm-ssl").forEach((a) => {
    a.addEventListener("click", (e) => {
      e.preventDefault();

      Swal.fire({
        title: "Warning",
        showCancelButton: true,
        icon: "warning",
        text:
          "Before installing SSL certificate, please make sure you add an A record for this subdomain at your registrar pointing to the following IP address: 178.128.254.18. If you have already added the A record for this subdomain, click Proceed.",
        confirmButtonText: "Proceed",
        cancelButtonText: "Cancel",
        showLoaderOnConfirm: true,
        allowOutsideClick: false,
        allowEscapeKey: false,
        preConfirm: () => {
          return Axios.get(window.location.href + a.getAttribute("href"));
        },
      }).then((response) => {
        const { isConfirmed } = response;

        if (isConfirmed) {
          a.classList.add("disabled");
        }
      });
    });
  });
});
