window.addEventListener("DOMContentLoaded", function () {
  var groups = "136",
    idContainer = "container_1",
    e = document.createElement("link");
  (e.rel = "stylesheet"),
    (e.type = "text/css"),
    (e.href = "https://app.ifunnels.com/skin/_css/funnels.css"),
    document.querySelector("head").appendChild(e);
  var t = new XMLHttpRequest();
  t.open("GET", "https://app.ifunnels.com/funnels/ajax/?groups=" + groups, !0),
    t.send(),
    (t.onreadystatechange = function () {
      if (4 == this.readyState)
        if (200 == this.status) {
          var e = JSON.parse(this.responseText);
          null !== e.arrTemplates &&
            Object.keys(e.arrTemplates).forEach(function (t, n) {
              e.arrTemplates[t].node.forEach(function (t) {
                var n = document.createElement("div");
                (n.className = "funnels_col-md-3"),
                  (n.innerHTML =
                    '<div class="funnels_item"><div class="funnels_item-description-box">' +
                    t.settings.template_description +
                    '</div><div><img src="' +
                    e.templates_link +
                    t.settings.template_hash +
                    '.jpg" class="funnels_image-item funnels_center-block" /></div><div class="funnels_m-t-10"><center><a href="' +
                    t.url +
                    '" class="funnels_btn funnels_btn-default funnels_waves-effect funnels_waves-light" target="_blank">Preview</a>' +
                    "</center></div><br/></div>"),
                  document.getElementById(idContainer).appendChild(n);
              });
            });
        } else
          console.log(
            "Error: " + (this.status ? this.statusText : "request failed")
          );
    });
});
