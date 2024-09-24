function getRand(min, max) {
    return Math.random() * (max - min) + min;
}

let snail = {};
onmessage = function(e) {
	if (e.data[0] === 'custom') {
		eval(`snail=${e.data[1]}`);
		console.log('snail is ',snail);
    if (snail.name) {
      postMessage(['name',snail.name])
    }
	}
  if (e.data[0] === 'start') {
    setInterval(function () {
      let r = ~~getRand(0, snail.slow || 10);
      if (r === 0) {
        postMessage(['move']);
      }
    }, 250);
  }
}
