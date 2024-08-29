'use strict';

let enabled = true;

// allow page onclick handler to send coordinates to background,
// keypress handler to toggle visibility,
// and websites to opt out entirely by sending a commentAnywhereDisable message
window.addEventListener('message', (event) => {
    console.log(event);

    if (event.source != window) {
        return;
    }

    if (event.data.type === 'commentAnywhereDisable') {
        enabled = false;
        Array.from(document.getElementsByClassName("comment-anywhere-indicator")).forEach((div) => {
            div.remove();
        });
    } else if (event.data.type === 'commentAnywhereToggleVisible') {
        Array.from(document.getElementsByClassName("comment-anywhere-indicator")).forEach((div) => {
            div.classList.toggle("comment-anywhere-invisible");
        });
    } else if (event.data.type === 'commentAnywhereSetCoords') {
        chrome.runtime.sendMessage({
            type: 'mousedown',
            ...event.data.coords,
        }, () => {});
    }
});

// dispatch from background to the injected handler
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (!enabled) {
        return true;
    }

    if (request.type === 'comments') {
        for (const comment of request.comments) {
            let commentIndicator = document.createElement('div');
            commentIndicator.className = 'comment-anywhere-indicator';
            commentIndicator.style.top = `${comment.coords.y}px`;
            commentIndicator.style.left = `${comment.coords.x}px`;

            let commentDiv = document.createElement('div');
            commentDiv.className = 'comment-anywhere-comment';
            commentDiv.innerHTML = comment.comment;
            commentIndicator.appendChild(commentDiv);

            document.body.appendChild(commentIndicator);
        }
    }

    return true;
});
