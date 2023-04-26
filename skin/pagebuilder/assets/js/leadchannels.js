(function () {
  "use strict";
  var URI = require("urijs");
  var validator = require("validator");

  var leadchannels = {
    $use_as_tag: null,
    $form: null,
    init: function () {
      document.addEventListener("DOMContentLoaded", function (event) {
        leadchannels.$form = $("[data-lead-channel]");
        leadchannels.$form.on("submit", function (e) {
          e.preventDefault();

          if (
            $(this).find('[name="email"]').length !== 0 &&
            !leadchannels.validateEmail(
              $(this).find('[name="email"]').prop("value")
            )
          ) {
            $(this)
              .find('[name="email"]')
              .closest(".form-group")
              .addClass("has-error");
          } else {
            if ($(this).find('[name="email"]').length !== 0)
              $(this)
                .find('[name="email"]')
                .closest(".form-group")
                .removeClass("has-error");

            let _message = $(this)
                .find("#_textareaCustomMessageLeadChannel")
                .prop("value"),
              _redirect = $(this).find("#_inputRedirectTo").prop("value"),
              _self = this;

            $.ajax({
              url: $(this).prop("action"),
              type: "POST",
              data: $(this).serialize(),
              dataType: "json",
            }).done(function (ret) {
              if (ret.status === "OK") {
                if (_message !== "") {
                  $(_self).html(
                    `<div class="alert alert-success" role="alert">${_message}</div>`
                  );
                }

                if (_redirect !== "") {
                  window.location.href = _redirect;
                }
              }

              if (ret.status === "error") {
                $(_self).prepend(
                  `<div class="alert alert-danger" role="alert">${ret.message}</div>`
                );
              }
            });
          }

          return false;
        });

        leadchannels.$use_as_tag = leadchannels.$form.find(
          'input[name="use_as_tag"]'
        );

        if (leadchannels.$use_as_tag.length) {
          var query = URI(window.location.href).search(true);
          var values = [];

          leadchannels.$use_as_tag.each(function () {
            values.push($(this).prop("value"));
          });

          var tags = values.map(function (value) {
            if (
              query.hasOwnProperty(value) &&
              !validator.isEmpty(value, { ignore_whitespace: true })
            ) {
              return query[value];
            }

            return null;
          });

          tags = tags.filter(function (t) {
            return t !== null;
          });

          if (tags.length) {
            leadchannels.$form.append(
              `<input type="hidden" name="_tags" value="${tags.join(", ")}" />`
            );
          }
        }
      });
    },
    validateEmail: function (email) {
      var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(String(email).toLowerCase());
    },
  };
  leadchannels.init();
})();
