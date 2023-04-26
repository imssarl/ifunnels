import Swal from "sweetalert2";
import 'style-loader!css-loader!./index.scss';

(() => {
  document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll("a.delete").forEach((a) =>
      a.addEventListener("click", (e) => {
        e.preventDefault();

        Swal.fire({
          title: "Warning",
          showCancelButton: true,
          icon: "warning",
          text: "Are you sure you want to delete this funnel?",
          confirmButtonText: "Proceed",
          cancelButtonText: "Cancel",
          allowOutsideClick: false,
          allowEscapeKey: false,
        }).then((response) => {
          const { isConfirmed } = response;

          if (isConfirmed) {
            window.location.replace(a.getAttribute('href'));
          }
        });
      })
    );
  });
})();
