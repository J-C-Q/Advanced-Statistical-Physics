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

function exponentialtypebeat(x) {
  var a = [];
  for (var i = 0; i<x.length;i++) {
    a.push(x[i]*Math.exp((1-x[i]))); 
  }
  return a;
}

var x = Range(0,10,100);
var f = exponentialtypebeat(x);

let delayed;
var ctx = document.getElementById('myChart').getContext('2d');
var chart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: x,
    datasets: [{
      label: 'x*e^(1-x)',
      backgroundColor: 'rgb(0,0,0)',
      borderColor: 'rgb(0,0,0)',
      data: f,
    }]
  },
  options: {
    scales: {
        x: {
          type: 'linear',
          min: 0,
          max: 4
        },
        y: {
          type: 'linear',
          ticks: {
            callback: function (value) {
              return value +"";
            }
          },
          min: 0,
          max: 1.2
        }
    },
    resposive: true,
    animation: {
      onComplete: () => {
        delayed = true;
      },
      delay: (context) => {
        let delay = 0;
        if (context.type === 'data' && context.mode === 'default' && !delayed) {
          delay = context.dataIndex * 100 + context.datasetIndex * 1;
        }
        return delay;
      },
  }
  }
});
