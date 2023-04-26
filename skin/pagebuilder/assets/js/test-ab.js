(function () {
  const axios = require("axios");
  const Cookies = require("js-cookie");
  const current_option = Cookies.get("testab") || "#";

  axios.post(
    "https://fasttrk.net/services/testab/view.php",
    { pageid, current_option },
    { headers: { "Content-Type": "multipart/form-data" } }
  );
})();
