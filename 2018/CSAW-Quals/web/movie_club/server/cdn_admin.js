window.old_fetch = window.fetch;
window.fetch = (x,y) => {
    if (y === undefined)
        y = {};
    let o = x.split('/',3)[2];
    if (o !== undefined && o.startsWith(window.location.host)) {
        let h = y.headers;
        if (y.headers === undefined)
            h = {};
        h['X-Admin-Secret'] = window.admin;
        y.headers = h;
    }
    return window.old_fetch(x,y);
}

for (let t of document.head.children) {
    if (t.tagName !== 'SCRIPT')
        continue;
    let { cdn, src } = t.dataset;
    if (cdn === undefined || src === undefined)
        continue;
    fetch(`//${cdn}/cdn/${src}`,{
        headers: {
            'X-Forwarded-Host':cdn
        }}
    ).then(r=>r.blob()).then(b=> {
        let u = URL.createObjectURL(b);
        let s = document.createElement('script');
        s.src = u;
        document.head.appendChild(s);
    });
}
