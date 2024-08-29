'use strict';

// send click coords upstream so we know where the context menu is clicked
// if the user adds a comment.
document.addEventListener('mousedown', (event) => {
    if (event.button == 2) {
        let p = {x: event.pageX, y: event.pageY};
        window.postMessage({type: 'commentAnywhereSetCoords', coords: {point: p}}, '*');
    }
});

// toggle with shift+c
document.addEventListener('keypress', (event) => {
    if (event.shiftKey && event.keyCode == 67) {
        window.postMessage({type: 'commentAnywhereToggleVisible'}, '*');
    }
});
