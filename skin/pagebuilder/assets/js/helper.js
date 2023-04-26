(() => {
  const helper = {
    parseMediaType: (url) => {
      if (
        /(?:youtube(?:-nocookie)?\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/.test(
          url.toString()
        )
      ) {
        return "youtube";
      }

      if (
        /(?:player\.)?vimeo\.com\/(?:video\/)?([0-9]*)/.test(url.toString())
      ) {
        return "vimeo";
      }

      return "mp4";
    },

    serializeArray: (element) => {
      // Setup our serialized data
      const serialized = {};
      const inputs = element.querySelectorAll("input, textarea, select");

      // Loop through each field in the form
      for (let i = 0; i < inputs.length; i++) {
        const field = inputs[i];

        // Don't serialize fields without a name, submits, buttons, file and reset inputs, and disabled fields
        if (
          !field.name ||
          field.disabled ||
          field.type === "file" ||
          field.type === "reset" ||
          field.type === "submit" ||
          field.type === "button"
        )
          continue;

        // If a multi-select, get all selections
        if (field.type === "select-multiple") {
          for (let n = 0; n < field.options.length; n++) {
            if (!field.options[n].selected) continue;

            if (!serialized.hasOwnProperty(field.name)) {
              serialized[field.name] = [];
            }

            serialized[field.name].push(field.options[n].value);
          }
        } else if (field.type == "checkbox" && field.checked) {
          if (!serialized.hasOwnProperty(field.name)) {
            serialized[field.name] = field.value;
          } else {
            serialized[field.name] = [serialized[field.name]];
            serialized[field.name].push(field.value);
          }
        } else if (field.type !== "checkbox" || field.checked) {
          serialized[field.name] = field.value;
        }
      }

      return serialized;
    },

    formatToCamelCase: (str) => {
      const splitted = str.split("-");
      if (splitted.length === 1) return splitted[0];

      return (
        splitted[0] +
        splitted
          .slice(1)
          .map((word) => word[0].toUpperCase() + word.slice(1))
          .join("")
      );
    },
  };

  module.exports = helper;
})();
