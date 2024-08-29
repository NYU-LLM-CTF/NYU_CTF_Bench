// Derived from https://github.com/webrtc/samples/blob/gh-pages/src/content/datachannel/basic/js/main.js

'use strict';

let connection;
let sendChannel;
let receiveChannel;
let answerPoll;
let sid;
const dataChannelSend = document.querySelector('input#dataChannelSend');
const dataChannelReceive = document.querySelector('textarea#dataChannelReceive');
const sendButton = document.querySelector('button#sendButton');
const closeButton = document.querySelector('button#closeButton');
const statusMsg = document.querySelector('#status');

sendButton.onclick = sendData;
closeButton.onclick = closeDataChannels;

function disableSendButton() {
  sendButton.disabled = true;
}

const iceConfiguration = {
    iceServers: [
        {
            urls: 'turn:web.chal.csaw.io:3478',
            username: '',
            credential: ''
        }
    ]
    // Doesn't work to force relay only transport, something must be busted...
    //iceTransportPolicy: "relay"
}

function createConnection() {
  dataChannelSend.placeholder = '';
  connection = new RTCPeerConnection(iceConfiguration);

    if (location.hash) {
        let sid = location.hash.substr(1);
          statusMsg.innerText = `Connecting to peer ${sid}`;
        fetch(`/api/join`, {
            method: "POST",
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({sid})
        })
        .then(opts => opts.json())
        .then(opts => {
            let offer = JSON.parse(opts['offer']);
            connection.setRemoteDescription(offer);
            connection.createAnswer(
                answer => {
                  statusMsg.innerText = `Sending answer to peer`;
                  closeButton.disabled = false;
                    fetch(`/api/join`, {
                        method: "PUT",
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({sid, answer: JSON.stringify(answer)})
                    });
                    connection.setLocalDescription(answer);
                },
                () => {
                    console.log("ERROR");
                }
            );
        });
    } else {
      statusMsg.innerText = "Creating session...";

      connection.onicecandidate = event => {
        if (event.candidate == null) {
            fetch(`/api/new`, {
                method: "POST",
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({offer: JSON.stringify(connection.localDescription)})
            })
            .then(resp => resp.json())
            .then(resp => {
                sid = resp.sid;
              statusMsg.innerText = `Waiting for peer (connect to ${window.location}/#${sid})`;
                answerPoll = setInterval(pollForAnswer, 1000);
            });
        }
      };

      connection.createOffer().then(
          offer => {
              connection.setLocalDescription(offer);
          },
          () => {
              console.log('Failed to create session description: ' + error.toString());
          }
      );
          closeButton.disabled = false;
    }

      sendChannel = connection.createDataChannel('sendDataChannel');
      sendChannel.onopen = onSendChannelStateChange;
      sendChannel.onclose = onSendChannelStateChange;

    connection.ondatachannel = receiveChannelCallback;
}

function pollForAnswer() {
    fetch(`/api/join`, {
        method: "POST",
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({sid})
    })
    .then(opts => opts.json())
    .then(opts => {
        if (opts.answer !== undefined) {
            let answer = JSON.parse(opts.answer);
            connection.setRemoteDescription(answer);
            clearInterval(answerPoll);
        }
    });
}

function sendData() {
  const data = dataChannelSend.value;
  sendChannel.send(data);
  dataChannelReceive.value += `You: ${data}\n`;
  dataChannelSend.value = '';
}

function closeDataChannels() {
  sendChannel.close();
  receiveChannel.close();
  connection.close();
  connection = null;
  sendButton.disabled = true;
  closeButton.disabled = true;
  dataChannelSend.value = '';
  dataChannelReceive.value = '';
  dataChannelSend.disabled = true;
  disableSendButton();
}

function receiveChannelCallback(event) {
  receiveChannel = event.channel;
  receiveChannel.onmessage = onReceiveMessageCallback;
  receiveChannel.onopen = onReceiveChannelStateChange;
  receiveChannel.onclose = onReceiveChannelStateChange;
}

function onReceiveMessageCallback(event) {
  dataChannelReceive.value += `Remote: ${event.data}\n`;
}

function onSendChannelStateChange() {
  const readyState = sendChannel.readyState;
  if (readyState === 'open') {
      statusMsg.innerText = "Connected!";
    dataChannelSend.disabled = false;
    dataChannelSend.focus();
    sendButton.disabled = false;
    closeButton.disabled = false;
  } else {
      statusMsg.innerText = "Disconnected";
    dataChannelSend.disabled = true;
    sendButton.disabled = true;
    closeButton.disabled = true;
  }
}

function onReceiveChannelStateChange() {
  const readyState = receiveChannel.readyState;
}

document.addEventListener('DOMContentLoaded', function() {
    createConnection();
}, false);
