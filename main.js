function NumberArray(N) {
  var a = [];
  for (var i = 0; i<N;i++) {
    a.push(i);
  }
  return a;
}

function Range(a,b,N) {
  var x = [];
  for (var i = a; i<=b; i+=(b-a)/(N-1)) {
    x.push(i);
  }   
  return x;
}

function exponentialtypebeat(r,x) {
  var a = [];
  for (var i = 0; i<x.length;i++) {
    a.push(x[i]*Math.exp(r*(1-x[i]))); 
  }
  return a;
}

function removeData(chart) {
  chart.data.labels.pop();
  chart.data.datasets.forEach((dataset) => {
      dataset.data.pop();
  });
  chart.update();
}

function addData(chart, label, data) {
  chart.data.labels.push(label);
  chart.data.datasets.forEach((dataset) => {
      dataset.data.push(data);
  });
  chart.update();
}

var slider = document.getElementById("myRange");
var output = document.getElementById("value");
output.innerHTML = slider.value/40;



var x = Range(0,10,500);
var f = exponentialtypebeat(0,x);

var ctx = document.getElementById('myChart').getContext('2d');
var chart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: x,
    datasets: [{
      label: 'x*e^(r-rx)',
      backgroundColor: '#FF652F',
      borderColor: '#FF652F',
      data: f,
    }]
  },
  options: {
    scales: {
        x: {
          type: 'linear',
          min: 0,
          max: 2,
          ticks: {
            callback: function(value, index) {
              return value;
            },
            font: {
              size: 25,
              family: 'Computer Modern Serif' 
            },
            color: 'rgb(255,255,255)'
          },
          grid: {
            lineWidth: 5,
            color: '#272727'
          }
        },
        y: {
          type: 'linear',
          min: 0,
          max: 2,
          ticks: {
            callback: function(value, index) {
              return value;
            },
            font: {
              size: 25,
              family: 'Computer Modern Serif',
            },
            color: 'rgb(255,255,255)'
          },
          grid: {
            lineWidth: 5,
            color: '#272727'
          }
        }
    },
    resposive: true,
    pointRadius: 0,
    maintainAspectRatio: false,
    showtooltips: false,
    events: [],
    animations: 'hide',
    plugins: {
      legend: {
        display: false
      }
    }
  }
});

slider.oninput = function() {
  output.innerHTML = this.value/40;
  var l = slider.value;
  //var color = 'rgb(214,214,214)';//'linear-gradient(90deg,rgb(0,0,117)'+l+'%, rgb(214,214,214)'+l+'%)';
  //slider.style.background=color;
  let newthig = l/40
  f = exponentialtypebeat(newthig,x);
  chart.data.datasets[0].data = f;
  chart.update('none');
}

/*
slider.addEventListener("mousemove", function() {
  var l = slider.value;
  var color = rgb(214,214,214);//'linear-gradient(90deg,rgb(0,0,117)'+l+'%, rgb(214,214,214)'+l+'%)';
  slider.style.background=color;
  let newthig = l/40
  f = exponentialtypebeat(newthig,x);
  chart.data.datasets[0].data = f;
  chart.update('none');
})*/






