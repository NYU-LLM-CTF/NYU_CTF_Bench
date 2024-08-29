console.log("Running app");

// Inject API into the page
var s = document.createElement('script');
s.src = chrome.extension.getURL('api.js');
s.onload = function() {
      this.parentNode.removeChild(this);
};
(document.head||document.documentElement).appendChild(s);

let messages = {};
let msg_id = 0;

// Open port to backend
var port = chrome.runtime.connect('dhmimogfeikijkmaadppammcbjflkpof',{name: "api"});

port.onMessage.addListener(msg => {
  console.log("Content script got from backend:", msg);
  if (msg.id === undefined)
    return;
  messages[msg.id](msg);
})

function send_message_to_backend(msg) {
  console.log("Sending message to backend",msg);
  return new Promise(resolve => {
    msg.id = msg_id;
    messages[msg_id++] = resolve;
    port.postMessage(msg);
  });
}

let uid = null;

// Get commands from the embedded webpage
window.addEventListener("message", function(event) {
  let respond = function(msg, resp) {
    resp.id = msg.id;
    resp.from = 'extension';
    console.log("Sending message to webpage",resp);
    event.source.postMessage(resp,'*');
  }

  let msg = event.data;
  if (msg.id === undefined || msg.from !== "page")
    return;

  console.log("Content script got from web:",msg);

  if (msg.type === 'status') {
    return send_message_to_backend({
      type: 'status'
    }).then(resp => respond(msg, resp));
  }

  if (msg.type === 'start') {
    return send_message_to_backend({
      type: 'new_instance',
      args: msg.args,
    }).then(resp => {
      uid = resp.uid
      respond(msg, resp)
    });
  }

  if (msg.type === 'open_debugger') {
    if (msg.uid === undefined) {
      msg.uid = uid;
    }
    return send_message_to_backend({
      type: 'open_debugger',
      uid: msg.uid
    });
  }

  if (msg.type === 'run' || 
      msg.type === 'breakpoint' || 
      msg.type === 'disassemble') {
    if (uid === null)
      return;

    let msg_c = Object.assign({}, msg);
    msg_c.uid = uid;
    return send_message_to_backend(msg_c).then(resp => respond(msg, resp));
  }
});
