// Initialize canvas
const canvas = document.getElementById('tennisCanvas');
const ctx = canvas.getContext('2d');
const p1NameInput = document.getElementById('p1Name');
const p2NameInput = document.getElementById('p2Name');
const submitButton = document.getElementById('submitButton');

// Game constants
const playerHeight = 50;
const playerWidth = 10;
const minSpeed = 1;
const maxSpeed = 10;
const speedStep = 1;
const ballSize = 10;

// Player variables
let dfltY = (canvas.height >> 1) - 25;
// let dfltY = 200;
let p1Y = dfltY;
let p2Y = dfltY;
let p1Name = 'Player 1';
let p2Name = 'Player 2';
let dfltSpeed = 5;
let p1Speed = dfltSpeed;
let p2Speed = dfltSpeed;

// Ball variables
let ballX = canvas.width >> 1;
let ballY = canvas.height >> 1;
let ballSpeedX = 4;
let ballSpeedY = 4;

// state variables
let gameStarted = false;
let p1Controls = [ "w", "s", "a", "d", "q", "e" ];
let p2Controls = [ "p", ";", "l", "'", "o", "[" ];
let logs = [];


function draw() {
    ctx.fillStyle = '#28a745';
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    ctx.strokeStyle = '#ffffff';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(canvas.width >> 1, 0);
    ctx.lineTo(canvas.width >> 1, canvas.height);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(0, 0);
    ctx.lineTo(canvas.width, 0);
    ctx.moveTo(0, canvas.height);
    ctx.lineTo(canvas.width, canvas.height);
    ctx.stroke();

    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, p1Y, playerWidth, playerHeight);
    ctx.fillRect(canvas.width - playerWidth, p2Y, playerWidth, playerHeight);

    ctx.beginPath();
    ctx.arc(ballX, ballY, ballSize, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = '#ffffff';
    ctx.font = '16px Arial';
    ctx.textAlign = 'left';
    ctx.fillText(p1Name + ' Controls:', 10, 20);
    ctx.fillText(p1Controls[0] + ' - Move Up', 10, 40);
    ctx.fillText(p1Controls[1] + ' - Move Down', 10, 60);
    ctx.fillText(p1Controls[2] + ' - Decrease Speed', 10, 80);
    ctx.fillText(p1Controls[3] + ' - Increase Speed', 10, 100);
    ctx.fillText(p1Controls[4] + ' - Reset Position', 10, 120);
    ctx.fillText(p1Controls[5] + ' - Reset Speed', 10, 140);
    
    ctx.textAlign = 'right';
    ctx.fillText(p2Name + ' Controls:', canvas.width - 10, 20);
    ctx.fillText('Move Up - ' + p2Controls[0], canvas.width - 10, 40);
    ctx.fillText('Move Down - ' + p2Controls[1], canvas.width - 10, 60);
    ctx.fillText('Decrease Speed - ' + p2Controls[2], canvas.width - 10, 80);
    ctx.fillText('Increase Speed - ' + p2Controls[3], canvas.width - 10, 100);
    ctx.fillText('Reset Position - ' + p2Controls[4], canvas.width - 10, 120);
    ctx.fillText('Reset Speed - ' + p2Controls[5], canvas.width - 10, 140);

    if (!gameStarted) {
        ctx.fillStyle = '#ffffff';
        ctx.font = '24px Arial';
        ctx.textAlign = 'center';
        ctx.fillText('PRESS ANY KEY TO START', canvas.width >> 1, canvas.height >> 1);
    }
}

function update() {
    if (!gameStarted) return;

    ballX += ballSpeedX;
    ballY += ballSpeedY;
    

    const isBounceY = ballY <= 0 || ballY >= canvas.height;
    
    if (isBounceY) {
        ballSpeedY = -ballSpeedY;
    }
    
    
    const isBounceXLeft = ballX <= playerWidth;
    const isOOBLeft = ballY <= p1Y || ballY >= p1Y + playerHeight;
    const isBounceXRight = ballX >= canvas.width - playerWidth;
    const isOOBRight = ballY <= p2Y || ballY >= p2Y + playerHeight;
    
    if (isBounceXLeft) {
        if (isOOBLeft) {
            resetBall();
        }
        
        ballSpeedX = -ballSpeedX;
    }

    else if (isBounceXRight) {
        if (isOOBRight) {
            resetBall();
        }

        ballSpeedX = -ballSpeedX;
    }
}

function resetBall() {
    ballX = canvas.width >> 1;
    ballY = canvas.height >> 1;
}

function handlePlayerInput(event) {
    if (gameStarted) {    
        const key = event.key.toLowerCase();
        
        let player = 0;
        let isLogMe = true;

        switch (key) {
            case p1Controls[0]: // Move player 1 up
                if (p1Y > 0) p1Y -= p1Speed;
                break;
            case p1Controls[1]: // Move player 1 down
                if (p1Y < canvas.height - playerHeight) p1Y += p1Speed;
                break;
            case p1Controls[2]: // Decrease player 1 speed
                if (p1Speed > minSpeed) p1Speed -= speedStep;
                break;
            case p1Controls[3]: // Increase player 1 speed
                if (p1Speed < maxSpeed) p1Speed += speedStep;
                break;
            case p1Controls[4]: // Reset player 1 position
                p1Y = dfltY;
                break;
            case p1Controls[5]: // Reset player 1 speed
                p1Speed = dfltSpeed;
                break;
            
            case p2Controls[0]: // Move player 2 up
                if (p2Y > 0) p2Y -= p2Speed;
                player = 1;
                break;
            case p2Controls[1]: // Move player 2 down
                if (p2Y < canvas.height - playerHeight) p2Y += p2Speed;
                player = 1;
                break;
            case p2Controls[2]: // Decrease player 2 speed
                if (p2Speed > minSpeed) p2Speed -= speedStep;
                player = 1;
                break;
            case p2Controls[3]: // Increase player 2 speed
                if (p2Speed < maxSpeed) p2Speed += speedStep;
                player = 1;
                break;
            case p2Controls[4]: // Reset player 2 position
                p1Y = dfltY;
                break;
            case p2Controls[5]: // Reset player 2 speed
                p1Speed = dfltSpeed;
                break;
                
            default:
                isLogMe = false;
        }

        if (isLogMe) {
            const playerName = player === 0 ? p1Name : p2Name;
            const logKey = { player: playerName, key: key };
            
            logs.push(logKey);
            
            sendLogData();
        }
    }
}

function sendLogData() {
    fetch('/submit_logs', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(logs),
        keepalive: true
    })
    .then(resp => resp.json())
    .then((data) => {
        if (data?.status === 'success') {
            logs = [];
        } else {
            console.error('Failed to submit logs:', data?.reason);
        }
    })
    .catch(err => console.error('Error:', err));
    
}

function gameLoop() {
    update();
    draw();
    requestAnimationFrame(gameLoop);
}

function startGame() {
    gameStarted = true;
    
    fetch('/clear_logs', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        keepalive: true
    })
    .then(resp => resp.json())
    .then(data => {
        if (data?.status === 'success') {
            logs = [];
        } else {
            console.error('Failed to clear logs:', data?.reason);
        }
    })
    .catch(err => console.error('Error:', err));

    requestAnimationFrame(gameLoop);
}

submitButton.addEventListener('click', () => {
    const p1NameLocal = p1NameInput.value;
    const p2NameLocal = p2NameInput.value;

    if (p1NameLocal.trim() !== '' && p2NameLocal.trim() !== '') {
        p1Name = p1NameLocal;
        p2Name = p2NameLocal;

        document.querySelector('.player-inputs').style.display = 'none';
        
        let down = document.getElementById('p1Down').value;
        let up = document.getElementById('p1Up').value;
        let left = document.getElementById('p1Left').value;
        let right = document.getElementById('p1Right').value;
        let resetPos = document.getElementById('p1RstPos').value;
        let resetSpd = document.getElementById('p1RstSpd').value;
        
        if (down.length == 1) p1Controls[0] = down;
        if (up.length == 1) p1Controls[1] = up;
        if (left.length == 1) p1Controls[2] = left;
        if (right.length == 1) p1Controls[3] = right;
        if (resetPos.length == 1) p1Controls[4] = resetPos;
        if (resetSpd.length == 1) p1Controls[5] = resetSpd;
        
        down = document.getElementById('p2Down').value;
        up = document.getElementById('p2Up').value;
        left = document.getElementById('p2Left').value;
        right = document.getElementById('p2Right').value;
        resetPos = document.getElementById('p2RstPos').value;
        resetSpd = document.getElementById('p2RstSpd').value;
        
        if (down.length == 1) p2Controls[0] = down;
        if (up.length == 1) p2Controls[1] = up;
        if (left.length == 1) p2Controls[2] = left;
        if (right.length == 1) p2Controls[3] = right;
        if (resetPos.length == 1) p2Controls[4] = resetPos;
        if (resetSpd.length == 1) p2Controls[5] = resetSpd;
              
        startGame(); // Start the game with player names
        return;
    }
    
    alert('Please enter both player names.');
});


// Listen for player inputs
document.addEventListener('keydown', handlePlayerInput);

// Draw initial screen
draw();