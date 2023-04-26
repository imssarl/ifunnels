(function () {
  "use strict";

  const utils = require("./modules/shared/utils.js");
  const axios = require("axios");
  let delay = 1;

  Array.prototype.isEqualNode = function (currenNode) {
    return this.some((node) => currenNode.isEqualNode(node));
  };

  let quizes = null;

  const quiz = {
    init: function () {
      quizes = this.activateFirstQuestion();
      this.bindActions();
      this.questClickHandler = this.questClickHandler.bind(this);
      this.addStatistic = this.addStatistic.bind(this);

      quizes.forEach((quiz) => {
        this.updateProgressBar(
          quiz,
          1,
          quiz.querySelectorAll('[data-component="quest-box"]').length
        );
      });
    },

    bindActions: function () {
      document.querySelectorAll('[data-component="quest"]').forEach((quest) => {
        const _defaultBackground = quest.style.backgroundColor;

        quest.addEventListener("mouseenter", (e) => {
          e.target.style.backgroundColor =
            e.target.getAttribute("data-hover-color") || "#97d6ff";
        });

        quest.addEventListener("mouseleave", (e) => {
          e.target.style.backgroundColor = _defaultBackground;
        });

        quest.addEventListener("click", (e) => {
          e.preventDefault();

          e.currentTarget
            .closest('[data-component="quest"]')
            .querySelector('input[type="radio"]').checked = true;
          setTimeout(() => {
            this.questClickHandler(
              e.target.closest('[data-component="quest"]')
            );
          }, 200);

          const container = e.currentTarget
            .closest('[data-component="quest-box"]')
            .closest('[data-container="true"]');
          const currentIndex = this.getIndexFromArray(
            e.currentTarget.closest('[data-component="quest-box"]'),
            container.querySelectorAll('[data-component="quest-box"]')
          );
          this.updateProgressBar(
            container,
            currentIndex + 2,
            container.querySelectorAll('[data-component="quest-box"]').length
          );
        });
      });
    },

    /** Updating width for progressbar widget */
    updateProgressBar: function (container, currentValue, maxValue) {
      container
        .querySelectorAll('[data-component="quest-bar"]')
        .forEach((bar) => {
          $(bar.querySelector(".surveyStepProgressCounter")).animate(
            {
              width: `${(currentValue / maxValue) * 100}%`,
            },
            600
          );
        });
    },

    /** Return element index from array */
    getIndexFromArray: function (value, array) {
      let outputIndex = false;
      Array.from(array).forEach((node, index) => {
        if (node.isEqualNode(value)) {
          outputIndex = index;
        }
      });
      return outputIndex;
    },

    /** Handler for event click on a question */
    questClickHandler: function (element) {
      const nextQuestion = element.getAttribute("data-blockid");
      const questionContainer = element.closest('[data-component="quest-box"]');

      this.addStatistic(element);

      /** Hide a block question */
      questionContainer.style.display = "none";

      if (["open-url", "open-popup"].indexOf(nextQuestion) === -1) {
        document.querySelector(
          `[data-id="${nextQuestion}"][data-component="quest-box"]`
        ).style.display = "inline-block";
      } else if (nextQuestion === "open-popup") {
        const popupId = element.getAttribute("data-blockpopup");

        /** Show a popup */
        if (popupId !== null) {
          $(`#${popupId}`).modal("show");
        }

        setTimeout(() => this.resetQuiz());
      } else {
        const thanksMessage =
          utils.custom_base64_decode(
            element.getAttribute("data-blockthanks")
          ) || null;
        const redirectURL = element.getAttribute("data-blockurl");

        /** Show a thanks message */
        if (thanksMessage) {
          delay = 2000;
          questionContainer.innerHTML = this.parseThanksMessage(thanksMessage);
          questionContainer.style.display = "block";
        }

        /** Redirect to URL */
        if (redirectURL) {
          setTimeout(() => (window.location = redirectURL), delay);
        }
      }
    },

    /** Show first question on default */
    activateFirstQuestion: function () {
      const questionBoxList = document.querySelectorAll(
        '[data-component="quest-box"]'
      );
      const containerBox = [];

      questionBoxList.forEach((questionBox) => {
        if (!containerBox.isEqualNode(questionBox.parentNode)) {
          containerBox.push(questionBox.parentNode);
        }

        questionBox.style.display = "none";
      });

      if (containerBox.length) {
        containerBox.forEach((container) => {
          container.querySelector(
            '[data-component="quest-box"]'
          ).style.display = "inline-block";
        });
      }

      return containerBox;
    },

    /** Parsing thanks message and add return html code */
    parseThanksMessage: function (dataString) {
      const html = new DOMParser().parseFromString(dataString, "text/xml");

      /** If has error in parse then return html code */
      if (html.querySelector("parsererror")) {
        return `<p>${dataString}</p>`;
      }

      return html.documentElement.outerHTML;
    },

    resetQuiz: function () {
      this.activateFirstQuestion();

      quizes.forEach((quiz) => {
        this.updateProgressBar(
          quiz,
          1,
          quiz.querySelectorAll('[data-component="quest-box"]').length
        );
        quiz
          .querySelectorAll('input[type="radio"]')
          .forEach((input) => (input.checked = false));
      });
    },

    addStatistic: (element) => {
      const container = element
        .closest('[data-component="quest-box"]')
        .closest('[data-container="true"]')
        .closest("[data-id]");

      const quizBox = element.closest('[data-component="quest-box"]');

      /**
       * List of questions in quiz
       */
      const quizQuestions = quizBox.closest('[data-container="true"]').children;

      /**
       * Number of question
       */
      const indexQuestion = quiz.getIndexFromArray(quizBox, quizQuestions);

      axios
        .post(
          "//fasttrk.net/services/pb_quiz.php",
          {
            uid,
            siteid: pbid,
            pageid,
            index: indexQuestion,
            quiz_id: container.getAttribute("data-id"),
          },
          {
            headers: { "content-type": "application/x-www-form-urlencoded" },
          }
        )
        .then((response) => console.log(response));
    },
  };

  quiz.init();
})();
