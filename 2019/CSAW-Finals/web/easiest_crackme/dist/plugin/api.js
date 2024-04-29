// Unprivileged page inject

let messages = {};
let msg_id = 0;

function send_to_app(msg) {
  return new Promise(resolve => {
    msg.id = msg_id;
    msg.from = 'page';
    messages[msg_id++] = resolve;
    window.postMessage(msg, '*');
  });
}

window.addEventListener("message", function(event) {
  let msg = event.data;
  if (msg.id === undefined || msg.from !== "extension")
    return;
  messages[msg.id](msg);
});

(function (exports) {
  exports.status = function() {
    return send_to_app({type:'status'});
  }
  exports.start = function(guess) {
    return send_to_app({type:'start', args:[guess]});
  }
  exports.run = function() {
    return send_to_app({type:'run'});
  }
  exports.open_debugger = function() {
    send_to_app({type:'open_debugger'});
  }
})(window.CrackMe = {});
