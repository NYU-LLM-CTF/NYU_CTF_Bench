'use strict';

let config = {
    api: 'http://comment-anywhere.chal.csaw.io:8000',
    user: 'default',
};

let state = {
    pos: null,
};

chrome.runtime.onMessage.addListener(function(msg, sender, sendResponse) {
    // only allow from injected content on active page
    if (!(chrome.tab && chrome.tab.active)) {
        return true;
    }

    if (msg.type === 'mousedown') {
        state.pos = msg.point;
    }

    return true;
});

chrome.runtime.onMessage.addListener(function(msg, sender, sendResponse) {
    // only allow from config popup
    if (sender.id !== chrome.runtime.id) {
        return true;
    }

    switch (msg.type) {
        case 'setConfig':
            config[msg.key] = msg.value;
            break;
        case 'getConfig':
            sendResponse(config);
            break;
    }

    return true;
});

function escape(str) {
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function ctxtClick(info, tab) {
    if (state.pos !== null) {
        const comment = escape(prompt("Comment?"));
        fetch(`${config.api}/comment`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                url: tab.url,
                coords: state.pos,
                creator: config.user,
                comment: comment,
            }),
        });
    }
}

// on click sample callback with more params
var idConsole = chrome.contextMenus.create({
    title: 'Comment On This',
    onclick: ctxtClick,
})

chrome.webNavigation.onDOMContentLoaded.addListener(({url, tabId}) => {
    // inject default coordinate handler
    chrome.tabs.executeScript({
        file: 'inject.js',
    });

    let req_url = new URL(`${config.api}/comments`);
    req_url.search = new URLSearchParams({url: url}).toString();
    fetch(req_url).then(r => r.json()).then(j => {
        chrome.tabs.sendMessage(tabId, {
            type: "comments",
            comments: j,
        }, () => {});
    });
});
