async function get_data() {
  let req = await fetch('/check',{crendentials:'include'});
  return await req.json();
}

let is_betting;
let money = null;

function end_betting() {
  money = null;
  is_betting = false;
  document.getElementById('bet').disabled = true;
  document.getElementById('a').disabled = true;
  document.getElementById('b').disabled = true;
}
function start_betting() {
  is_betting = true;
  document.getElementById('bet').disabled = false;
  document.getElementById('a').disabled = false;
  document.getElementById('b').disabled = false;
  document.getElementById('bet').value = '';
}

let to = null;


async function update() {
  let data = await get_data();

  let now = parseInt(+new Date()/1000);
  let left = data.start - now;

  if (data.bet) {
    document.getElementById('bet').value = data.bet;
  }

  if (money == null) {
    document.getElementById('money').innerText = `Money: $${data.money}`;
  } else if (money != data.money) {
    let dif = data.money - money;
    document.getElementById('money').innerText = 
      `Money: $${data.money} (${dif < 0 ? 'lost' : 'won'} $${dif})`;
  }
  money = data.money;

  if (money >= 250000) {
     document.getElementById('namediv').style.display='block';
  }
  if (money >= 1000000000000000000) {
     document.getElementById('flagdiv').style.display='block';
  }

  let odds = null;
  if (data.a != 0) {
    let a = data.a;
    let b = data.b;
    if (a > b) {
      b = 1;
    } else {
      a = 1;
    }
    odds = `A   ${a.toPrecision(3)}:${b.toPrecision(3)}   B`
  }
  if (odds) {
    let info = 
`Total Wagered:
Snail A: $${data.a_sum}
Snail B: $${data.b_sum}

Odds:
${odds}
`;
    if (data.bet) {
      let win = data.bet * [data.b,data.a][data.side];
      document.getElementById('odds').innerText = 
`${info}
Your Wagered $${data.bet}
+$${parseInt(win)} If Correct
-$${data.bet} If Wrong`;
    } else {
      document.getElementById('odds').innerText = info;
    }
  } else {
    document.getElementById('odds').innerText = `Betting Is Open`;
  }

  if (data.bet) {
    document.getElementById('status').innerText =
      `Bet $${data.bet} on Snail ${['A','B'][data.side]}`
  } else if (left < 0) {
    document.getElementById('status').innerText = `Betting closed`
  } else {
    document.getElementById('status').innerText = ``
  }

  if (left > 2) {
    if (!is_betting && !data.bet)
      start_betting()

    clearTimeout(to);
    to = setTimeout(function() {
      update();
    }, left*1000-1000)
  } else {
    if (is_betting) {
      end_betting();
    }

    clearTimeout(to);
    to = setTimeout(function() {
      update();
    }, 2000)
  }
}

async function place_bet(n) {
  if (!is_betting)
    return;
  let bet = document.getElementById('bet').value;
  let req = await fetch(`/bet/${n}`, {
    method:'PATCH',
    credentials:'include',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body:`bet=${bet}`
  });
  let data = await req.json();
  if (!data.success) {
    document.getElementById('error').innerText = data.error;
    return;
  }
  document.getElementById('error').innerText = '';
  end_betting();
  update();
}

async function send_name() {
  let name = document.getElementById('name').value;
  let req = await fetch(`/name`, {
    method:'PATCH',
    credentials:'include',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body:`name=${encodeURIComponent(name)}`
  });
  let data = await req.json();
  if (!data.success) {
    document.getElementById('error2').innerText = data.error;
    return;
  }
  document.getElementById('error2').innerText = 'Name Queued';
  document.getElementById('name').value = '';
  //document.getElementById('namebutton').disabled = true;
  setTimeout(()=>{
    document.getElementById('namebutton').disabled = false;
  }, 2*60000);
}
async function get_flag(n) {
  let name = document.getElementById('name').value;
  let req = await fetch(`/flag${n}`, {
    credentials:'include',
  });
  let data = await req.json();
  if (!data.success) {
    document.getElementById(`flag`).innerText = data.error;
    return;
  }
  document.getElementById(`flag`).innerText = data.flag;
}

document.getElementById('a').addEventListener('click', ()=>place_bet(0))
document.getElementById('b').addEventListener('click', ()=>place_bet(1))

document.getElementById('namebutton').addEventListener('click', ()=>send_name())
document.getElementById('flag1button').addEventListener('click', ()=>get_flag(1))
document.getElementById('flag2button').addEventListener('click', ()=>get_flag(2))

update()

new Twitch.Embed("stream", {
	width: '100%',
	height: 400,
	channel: "snail_race",
	layout: "video-with-chat",
});
