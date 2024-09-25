$(function() {
    var update = function(data) {
        $('#tokens').text(data.tokens);
        $('#message').text(data.message);

        if('state' in data) {
            window.localStorage['state'] = data.state;
        }
    };

    $('button').click(function(e) {
        var val = e.currentTarget.value;
        $.ajax({
            url: '/buy',
            method: 'post',
            data: {
                bid: parseInt(val),
                state: window.localStorage['state']
            },
            success: update
        });
    });

    $.ajax({
        url: '/tokens',
        success: update
    });
});
