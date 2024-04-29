console.log("In background");

let tabMap = {};

let msg_id = 0;
let messages = {};

var rpc = chrome.runtime.connectNative('io.csaw.ctf.crackme_debugger');
rpc.onMessage.addListener(function(msg) {
    console.log("Got rpc message",msg)
    if (msg.id === undefined)
      return;

    let f = messages[msg.id];
    if (f === undefined)
      return;

    f(msg);
});

function send_message_to_rpc(msg) {
  console.log("Sending message to rpc",msg);
  return new Promise(resolve => {
    msg.id = msg_id;
    messages[msg_id++] = resolve;

    try {
      rpc.postMessage(msg);
    } catch(e) {}
  });
}

rpc.onDisconnect.addListener(function() {
    console.log("RPC Disconnected!");
});



class CrackMe {
  constructor(tabid, port) {
    this.tabid = tabid;
    this.port = port;

    this.onTabMessage = this.onTabMessage.bind(this)
  }

  respond_to(msg, response) {
    response.id = msg.id;
    this.port.postMessage(response);
  }

  onTabMessage(msg) {
    console.log("Got message from tab:",msg,self.tabid);

    if (msg.type === 'status') {
      Promise.race([
        send_message_to_rpc({type:'status'}),
        new Promise(resolve => {
          setTimeout(x=>{
            resolve(null);
          },1000);
        })
      ]).then(resp => {
        if (resp === null)
          return this.respond_to(msg, {rpc:false});
        return this.respond_to(msg, resp);
      });
      return;
    }

    if (msg.type === 'open_debugger') {
      chrome.tabs.create({ 
        url: `${chrome.runtime.getURL("debugger.html")}?uid=${msg.uid}` });
      this.respond_to(msg, {success:true});
      return;
    }

    if (msg.type === 'new_instance') {
      send_message_to_rpc({
        type:'new_instance',
        args: msg.args,
      }).then(resp => {
        this.respond_to(msg, {success:true, uid: resp.uid});
      });
      return;
    }

    if (msg.type === 'run' ||
        msg.type === 'registers' ||
        msg.type === 'memory' ||
        msg.type === 'breakpoint' ||
        msg.type === 'flavor' ||
        msg.type === 'si' ||
        msg.type === 'ni' ||
        msg.type === 'continue' ||
        msg.type === 'disassemble'
       ) {
      let msg_c = Object.assign({}, msg);
      return send_message_to_rpc(msg_c).then(resp => this.respond_to(msg, resp));
    }

  }

}

// Handle a new tab connecting
chrome.runtime.onConnect.addListener(port => {
    let tab = port.sender.tab;

    let manager = new CrackMe(tab.id, port);
    tabMap[tab.id] = manager;

    port.onMessage.addListener(manager.onTabMessage);
});


