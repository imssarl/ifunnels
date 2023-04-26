import Chart from "chart.js";

window.chartColors = {
  red: "rgb(255, 99, 132)",
  orange: "rgb(255, 159, 64)",
  yellow: "rgb(255, 205, 86)",
  green: "rgb(75, 192, 192)",
  blue: "rgb(54, 162, 235)",
  purple: "rgb(153, 102, 255)",
  grey: "rgb(201, 203, 207)",
};

export const pie = ({ ctx, title, data, backgroundColor, labels }) => {
  return new Chart(ctx, {
    type: "pie",
    data: {
      datasets: [
        {
          data,
          backgroundColor,
        },
      ],
      labels,
    },
    options: {
      responsive: true,
      legend: {
        position: "left",
      },
    },
  });
};

export const line = ({ ctx, title, data, backgroundColor, labels }) => {
  return new Chart(ctx, {
    type: "line",
    data: {
      datasets: [{ data, backgroundColor, borderWidth: 0 }],
      labels,
    },

    options: {
      responsive: true,
      legend: {
        display: false,
      },
      tooltips: {
        mode: "index",
      },
      hover: {
        mode: "index",
      },
      elements: {
        line: {
          tension: 0.000001,
        },
      },
      scales: {
        xAxes: [
          {
            gridLines: {
              display: false,
            },
            scaleLabel: {
              display: true,
              labelString: "Date",
            },
          },
        ],
        yAxes: [
          {
            gridLines: {
              display: false,
            },
            scaleLabel: {
              display: true,
              labelString: "Count",
            },
          },
        ],
      },
    },
  });
};
