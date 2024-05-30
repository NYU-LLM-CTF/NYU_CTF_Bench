$(".form-signin").submit(function () {
    var $password = $(this).find("input[type=password]");
    $password.val(CryptoJS.SHA1($password.val()).toString());
});
