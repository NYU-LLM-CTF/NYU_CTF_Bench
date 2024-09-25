$(function() {
    var map = ['fog.png', 'wall.png', 'hole.png', 'lava.png', 'mystery.png', 'soil.png', 'water.png', 'stairs.png'];

    var update = function(data) {
        $('#hp-field').text(data['curr_hp']);
        $('#maxhp-field').text(data['max_hp']);
        $('#food-field').text(data['food']);
        $('#level-field').text(data['level']);
        $('#message').text(data['message']);

        for(var i = 0; i < 9; ++i) {
            $('.tile-' + (i + 1)).attr('src', '/static/img/tile/' + map[data['tiles'][i]]);
        }
        window.localStorage['state'] = data['state'];
    };

    var new_game = function() {
        $.ajax({
            url: '/new_game',
            success: update
        });
    };

    var status = function(mdir) {
        $.ajax({
            url: '/status',
            method: 'post',
            data: {
                state: window.localStorage['state']
            },
            success: update
        });
    };

    var action = function(mdir) {
        $.ajax({
            url: '/action',
            method: 'post',
            data: {
                move: mdir,
                state: window.localStorage['state']
            },
            success: update
        });
    };

    $('.up').click(function() { action(0) });
    $('.down').click(function() { action(1) });
    $('.left').click(function() { action(2) });
    $('.right').click(function() { action(3) });

    if(!('state' in localStorage)) {
        new_game();
    } else {
        status();
    }
});
