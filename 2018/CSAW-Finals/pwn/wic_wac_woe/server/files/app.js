function get_args() {
    try {
        return JSON.parse(atob(decodeURIComponent(location.hash.slice(1))))
    } catch(e) {}

    return {
        plays:[],
        api: "/check_flag"
    }
}

function make_string(s) {
    let buffer = Module._malloc(s.length+1);
    Module.writeAsciiToMemory(s, buffer);
    return buffer;
}

var is_game_over = false;
function game_over() {
    is_game_over = true;
    document.getElementById("move").disabled = true;
    document.getElementById("playbtn").disabled = true;
}


var moves = [{name:'guest'}];
function play() {
    if (is_game_over)
        return;
    let m = document.getElementById("move").value;
    let s = make_string(m);
    let res = Module.ccall("play_game", "boolean", ["number"], [s]);
    if (!res) {
        alert("Invalid move!");
    }

    moves.push(btoa(m));
}

function share() {
    let o = {api:'/check_flag', plays:moves};
    window.open('/share#'+btoa(JSON.stringify(o)));
}

function save() {
    let o = {api:'/check_flag', plays:moves};
    location = '#'+btoa(JSON.stringify(o));
}

function play_game() {

}

function place_move(r,c,p) {
    document.getElementById(r+''+c).innerHTML=['X','O'][p-1];
}

function run_app(flags) {
    let args = get_args();

    //let dump = Module.cwrap("_dump", "", ["number","number"]);
    Module.ccall("init_app", "",
                 ["string","string"],
                 [args.api, flags.flag1]);

    if (args.plays.length === 0) {
        return play_game();
    }
    for (let p of args.plays) {
        if (p.name !== undefined) {
            let s = make_string(p.name.toString());
            Module.ccall("set_username", "boolean", ["number"], [s]);
            continue;
        }
        moves.push(p);

        let data = atob(p);
        let s = make_string(data);
        Module.ccall("play_game", "boolean", ["number"], [s]);
    }
}

function get_flags() {
    fetch('flags',{credentials: 'include'}).then(r=>r.json()).then(run_app);
}

for (let i=0; i<3; i++) {
    for (let j=0; j<3; j++) {
        ((i,j)=>{
            document.getElementById(`${i}${j}`).addEventListener('click', ()=>{
                document.getElementById("move").value=`${i},${j}`;
                play();
            });
        })(i,j);
    }
}

var Module = {
    preRun: [],
    postRun: get_flags,
    print: (function() {
        return function(text) {
            if (arguments.length > 1) text = Array.prototype.slice.call(arguments).join(' ');
            console.log(text);
        }
    })(),
    printErr: function(text) {
        if (arguments.length > 1) text = Array.prototype.slice.call(arguments).join(' ');
        console.error(text);
    },
    totalDependencies: 0,
    noExitRuntime: true,
};
