<html>
<head>
<title>Secure File Storage - Home</title>
</head>
<body>
<?php if (isset($err)) { echo "<p>$err</p>"; } ?>
<form method="POST" id="uploadForm">
File: <input type="file" id="file">
<input type="submit" value="Upload" />
</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/crypto-js.min.js"></script>
<script>
if (localStorage.encryptSecret === undefined) {
    var secret = new Uint8Array(32);
    window.crypto.getRandomValues(secret);
    localStorage.encryptSecret = btoa(String.fromCharCode.apply(null, secret));
}

$("#uploadForm").submit(function(e) {
    e.preventDefault();
    var f = $("#file")[0].files[0];
    if (!f) {
        alert("You must select a file!");
    } else {
        var fr = new FileReader();
        var fn = f.name;
        fr.onload = function(file) {
            var ciphertext = CryptoJS.AES.encrypt(fr.result, atob(localStorage.encryptSecret)).toString();
            $.post({
                url: "/api/v1/file/edit",
                data: {path: fn, content: btoa(ciphertext)}
            }).done(function() {
                location.reload();
            });
        };
        fr.readAsText(f);
    }
});

// if secret not in storage
</script>
</body>
</html>
