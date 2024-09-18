var codeMirror = CodeMirror.fromTextArea(document.getElementById('editor'), {
    lineNumbers: true,
    matchBrackets: true,
    mode: 'javascript',
});

$('#submit').click(function() {
    $('#submit').addClass('disabled');
    $('#spinner').removeClass('invisible');
    $('#output').text('');
    $.post('/query.php',
           {
               'code': codeMirror.getValue(),
           },
           function (output) {
               $('#output').text(output);
               $('#submit').removeClass('disabled');
               $('#spinner').addClass('invisible');
           }
    );
});
