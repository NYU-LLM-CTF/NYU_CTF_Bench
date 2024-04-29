let messages = {};
let msg_id = 0;

var port = chrome.runtime.connect('dhmimogfeikijkmaadppammcbjflkpof',{name: "api"});

port.onMessage.addListener(msg => {
  console.log("Debugger got from backend:", msg);
  if (!(msg.id in messages))
    return;
  messages[msg.id](msg);
})

function send_message_to_backend(msg) {
  return new Promise(resolve => {
    msg.id = msg_id;
    console.log("Sending message to backend",msg);
    messages[msg_id++] = resolve;
    port.postMessage(msg);
  });
}

let uid = window.location.search.split('=')[1];


let cancel_load = ()=>{};

let render_id = 0;

function render_context() {
  return Promise.all([
    update_registers(++render_id),
    update_code(),
    update_stack()
  ]);
}

function update_registers(id) {
  return send_message_to_backend({type: 'registers', uid:uid}).then(reg_msg=>{
    let regs = reg_msg.registers;
    let waiting = [];

    let loc = $('#registers').empty();

    for (let name in regs) {
      let val = regs[name];
      loc.append($(`<div>${name}: ${val}</div>`));
      if (val.length < 6)
        continue;

      let p = send_message_to_backend(
        {type: 'memory', arg: '1s '+val, uid: uid}
      ).then(mem_msg => {
        let data = mem_msg.data;
        // Split on first tab
        data = data.substr(data.indexOf('\t')+1);

        if (!data.startsWith('<error') 
            // Ignore non ascii data
            && data.search(/\\\d+/) === -1) {
          regs[name] += ` -> ${data}`;
        }

      });

      waiting.push(p);
    }

    // Redraw registers
    Promise.all(waiting).then(()=>{
      // Make sure we are not updating old info
      if (render_id !== id)
        return;

      loc.empty();
      for (let name in regs) {
        loc.append($(`<div>${name}: ${regs[name]}</div>`));
      }
    });
  });
}

function update_code() {
  return send_message_to_backend({type: 'disassemble', addr: '$rip,+0x30', uid:uid}).then(msg=>{
    let text = msg.data;
    $('#code').text(text);
  });
}

function update_stack() {
  return send_message_to_backend({type: 'memory', arg: '32xg $rsp', uid:uid}).then(msg=>{
    let text = msg.data;
    $('#stack').text(text);
  });
}

pause();
render_context().then(unpause);

let flavors = ['att','intel'];

$('#flavor').change(x=>{
  let val = $('#flavor').children("option:selected").val();
  send_message_to_backend({
    type: 'flavor',
    flavor: `disassembly-flavor ${val}`, 
    uid: uid
  }).then(msg=>{
    update_code()
  });
});

function pause() {
  $('#si').attr("disabled", true);
  $('#ni').attr("disabled", true);
  $('#run').attr("disabled", true);
  $('#cont').attr("disabled", true);
}

function unpause() {
  $('#si').attr("disabled", false);
  $('#ni').attr("disabled", false);
  $('#cont').attr("disabled", false);
  $('#run').attr("disabled", false);
}

$('#si').click(x=>{
  pause();
  send_message_to_backend({
    type: 'si',
    uid: uid
  }).then(msg =>{
    unpause();
    render_context().then(unpause);
  });
});

$('#ni').click(x=>{
  pause();
  send_message_to_backend({
    type: 'ni',
    uid: uid
  }).then(msg =>{
    unpause();
    render_context().then(unpause);
  });
});

$('#run').click(x=>{
  pause();
  send_message_to_backend({
    type: 'run',
    uid: uid
  }).then(msg =>{
    render_context().then(unpause);
  });
});

$('#cont').click(x=>{
  pause();
  send_message_to_backend({
    type: 'continue',
    uid: uid
  }).then(msg =>{
    render_context().then(unpause);
  });
});

$('#meminp').submit(x=>{
  let cmd = $('#meminp').find('input')[0].value;
  if (cmd.startsWith('x/')) {
    send_message_to_backend({
      type: 'memory',
      uid: uid,
      arg: cmd.slice(2)
    }).then(msg => {
      $('#memory').text(msg.data);
    });
  } else if (cmd.startsWith('b *')) {
    send_message_to_backend({
      type: 'breakpoint',
      uid: uid,
      addr: cmd.slice(3)
    }).then(msg => {
      $('#memory').text(`Breakpoint set at ${cmd.slice(3)}!`);
    });
  }
  return false;
});
