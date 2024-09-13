const thanks = document.getElementById('thanks');
const dirt = document.getElementById('dirt')

function deep_eval(expr) {
    try {
        let result = eval(expr);
        while (typeof result === 'string' && result !== expr) {
            expr = result;
            result = eval(expr);
        }
        return result;
    } catch (e) {
        return expr;
    }
}

document.getElementById('reportForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const reported = document.getElementById('playerName').value;

    fetch('/get_moves', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ playerName: reported })
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {

            fetch('/get_eval', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ expr: deep_eval(data.result) })
            })
            .then(response => response.json())
            .then(data => {
                dirt.innerHTML = data.result;
            })
            .catch(error => {
                console.error('Error evaluating logs:', error);
                dirt.innerHTML = 'Internal error';
                dirt.style.display = 'block';
                thanks.style.display = 'block';
            })
            // dirt.innerHTML = deep_eval(data.result);
            // dirt.innerHTML = data.result;
        } else {
            dirt.innerHTML = 'Error: ' + data.reason;
        }
        thanks.style.display = 'block';
        dirt.style.display = 'block';
    })
    .catch(error => {
        console.error('Error fetching logs:', error);
        dirt.innerHTML = 'Internal error';
        dirt.style.display = 'block';
        thanks.style.display = 'block';
    });
});