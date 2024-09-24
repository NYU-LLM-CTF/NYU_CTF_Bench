var token = null;

Promise.all([
    fetch('/api/movies').then(r=>r.json()),
    fetch(`//{{ host }}/cdn/main.mst`).then(r=>r.text()),
    new Promise((resolve) => {
        if (window.loaded_recapcha === true)
            return resolve();
        window.loaded_recapcha = resolve;
    }),
    new Promise((resolve) => {
        if (window.loaded_mustache === true)
            return resolve();
        window.loaded_mustache = resolve;
    })
]).then(([user, view])=>{
    document.getElementById('content').innerHTML = Mustache.render(view,user);

    grecaptcha.render(document.getElementById("captcha"), {
        sitekey: '6Lc8ymwUAAAAAM7eBFxU1EBMjzrfC5By7HUYUud5',
        theme: 'dark',
        callback: t=> {
            token = t;
            document.getElementById('report').disabled = false;
        }
    });
    let hidden = true;
    document.getElementById('report').onclick = () => {
        if (hidden) {
          document.getElementById("captcha").parentElement.style.display='block';
          document.getElementById('report').disabled = true;
          hidden = false;
          return;
        }
        fetch('/api/report',{
            method: 'POST',
            body: JSON.stringify({token:token})
        }).then(r=>r.json()).then(j=>{
            if (j.success) {
                // The admin is on her way to check the page
                alert("Neo... nobody has ever done this before.");
                alert("That's why it's going to work.");
            } else {
                alert("Dodge this.");
            }
        });
    }
});


