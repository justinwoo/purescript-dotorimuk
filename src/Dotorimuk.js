var Chart = require('chart.js');

exports.makeBarChart_ = function (context) {
  return function (spec) {
    return function () {
      var spec_ = Object.assign({}, spec, {
        options: {
          scales: {
            yAxes: [
              {
                ticks: {
                  beginAtZero: true
                }
              }
            ]
          }
        }
      });

      return new Chart.Bar(context, spec_);
    };
  };
};
