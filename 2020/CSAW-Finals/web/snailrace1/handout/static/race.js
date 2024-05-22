let snails = {};

var c = document.getElementById('c');
var context = c.getContext("2d");

function drawSnail(cx,cy, color) {
  let a = 1;
  let b = 3;

  context.save();
	context.beginPath();
  context.moveTo(0, cy+28);
  context.lineTo(cx+10, cy+28);
  context.strokeStyle = '#8dfaff80';
  context.lineWidth = 10;
	context.stroke();
  context.restore();

  context.drawImage(snail, cx-20, cy-45, 80, 80);

  context.save();
  context.moveTo(cx, cy);
	context.beginPath();

  let x,y;
	for (let i = 0; i < 130; i++) {
			angle = 0.1 * i;
			x = cx + (a + b * angle) * Math.cos(angle);
			y = cy + (a + b * angle) * Math.sin(angle);

			context.lineTo(x, y);
	}
	context.fillStyle = color;
	context.fill();
	context.strokeStyle = "#000";
  context.lineWidth = 1;
	context.stroke();

  
  context.restore();
}

let step_size = 50;
let end = 15

let snail_id = 0;
let last_frame = null;
let winner = null;

var road = new Image();
road.src = '/static/road.png';
var snail = new Image();
snail.src = '/static/snail.png';
var finish= new Image();
finish.src = '/static/finish.png';

function draw() {
  //context.globalCompositeOperation = 'destination-over';
  context.clearRect(0, 0, 1000, 1000);
  //context.drawImage(road, 0, 0, 1000, 359);
  context.drawImage(road, 0, 0);
  context.drawImage(finish, 40+end*step_size, 0, 40,400);

  let now = +new Date();
  if (last_frame != null) {
    let delta = now - last_frame;
    for (let i=0; i<snail_id; i++) {
      let snail = snails[i];

      let snail_pos = snail.position*step_size;
      if (snail.x < snail_pos) {
        let mul = delta/1000.0;
        snail.x = Math.min(snail.x + mul*step_size, snail_pos);
        if (winner === null && snail.x >= end * step_size) {
          winner = snail;
          console.log('winner!',i)

          if (snail.name) {
            document.getElementById('time').innerText = `${snail.name} wins!`;
          } else {
            document.getElementById('time').innerText = `${snail.color_name} Snail wins!`;
          }
          ConfettiManager.drop(2000)

	  setTimeout(()=>{
		  fetch(`/win/${i}`, {credentials:'include'}).then(()=>{
		    setTimeout(()=>{
		      fetch(`/switch/setup`, {credentials:'include'});
		      setTimeout(()=>{
			location.reload();
		      }, 10000);
		    }, 1000);
		  });
	  }, 5000);
        }
      }
    }
  }
  last_frame = now;

  for (let i=0; i<snail_id; i++) {
    let snail = snails[i];
    drawSnail(40 + snail.x, 130 +80 * i,snail.color);
  }
  window.requestAnimationFrame(draw);
}

let time_left = Infinity;
async function run() {
  let req = await fetch('/snails');
  let data = await req.json();

  time_left = data.start*1000 - parseInt(+new Date);

  for (let snail_data of data.snails) {
    let worker = new Worker('/static/snail.js');
    let snail = {
      id: snail_id,
      name: undefined,
      color_name: snail_data.color,
      color: snail_data.color.replaceAll(' ',''),
      position: 0,
      custom: snail_data.custom,
      x:0,
      worker: worker
    };
    snails[snail_id] = snail;
    document.getElementById(snail.id == 0? 'a' : 'b').innerText =
      `Snail ${snail.id == 0? 'A' : 'B'}: ${snail.color_name} Snail`;

    worker.onmessage = function(e) {
      console.log(e.data);
      if (e.data[0] === 'name' && snail.name === undefined) {
        snail.name = e.data[1].slice(0,5);
        document.getElementById(snail.id == 0? 'a' : 'b').innerText =
          `Snail ${snail_id == 0? 'A' : 'B'}: ${snail.name}`;
      }
      if (time_left <= 0 && e.data[0] === 'move') {
        snail.position++;
      }
    }
    worker.postMessage(['custom', snail.custom]);

    snail_id++;
  }

  setTimeout(function() {
    console.log("Starting Race");
    for (let snail of Object.values(snails)) {
      snail.worker.postMessage(['start']);
    }
    window.requestAnimationFrame(draw);
  }, time_left + 1000);

  setTimeout(()=>{
    window.requestAnimationFrame(draw);
    fetch(`/switch/race`, {credentials:'include'});
  }, 2000);

  let iv = setInterval(function() {
    time_left = data.start*1000 - parseInt(+new Date)
    if (time_left <= 0) {
      document.getElementById('time').innerText = `And they are off!`;
      clearInterval(iv)
      return;
    }
    document.getElementById('time').innerText = `Race starts in ${parseInt(time_left/1000)}`;
  });


  window.requestAnimationFrame(draw);
}

run()
