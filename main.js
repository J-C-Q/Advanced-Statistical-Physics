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

slider.oninput = function() {
  output.innerHTML = this.value/40;
}

var x = Range(0,10,500);
var f = exponentialtypebeat(0,x);

let delayed;
var ctx = document.getElementById('myChart').getContext('2d');
var chart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: x,
    datasets: [{
      label: 'x*e^(r-rx)',
      backgroundColor: 'rgb(0,0,0)',
      borderColor: 'rgb(0,0,0)',
      data: f,
    },{
      label: 'x',
      backgroundColor: 'rgb(0,0,0)',
      borderColor: 'rgb(0,0,0)',
      data: x,
    }]
  },
  options: {
    showPoint: false,
    scales: {
        x: {
          type: 'linear',
          min: 0,
          max: 2
        },
        y: {
          type: 'linear',
          ticks: {
            callback: function (value) {
              return value +"";
            }
          },
          min: 0,
          max: 2
        }
    },
    resposive: true,
    pointRadius: 0
  }
});


slider.addEventListener("mousemove", function() {
  var l = slider.value;
  var color = 'linear-gradient(90deg,rgb(0,0,117)'+l+'%, rgb(214,214,214)'+l+'%)';
  slider.style.background=color;
  let newthig = l/40
  f = exponentialtypebeat(newthig,x);
  chart.data.datasets[0].data = f;
  chart.update('none');
})






