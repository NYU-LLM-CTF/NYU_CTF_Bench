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
