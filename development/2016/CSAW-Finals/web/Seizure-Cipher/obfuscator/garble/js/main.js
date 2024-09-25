$( document ).ready( function() {

    var _invokeTestResults = function() {

        ( window.angular ) ? console.log( "angular passed" ) : console.log( "angular failed" );
        ( window.$ ) ? console.log( "jquery passed" ) : console.log( "jquery failed" );
        ( window._ ) ? console.log( "underscore passed" ) : console.log( "underscore failed" );

        $( "body" ).append( "<script type='text/javascript' src='test/results/testDeleteErrorResults.js'></script>" );
        $( "body" ).append( "<script type='text/javascript' src='test/results/testHashNotationFuncInvocWPromiseResults.js'></script>" );
        $( "body" ).append( "<script type='text/javascript' src='test/results/testHashNotationFunctionInvocationResults.js'></script>" );
        $( "body" ).append( "<script type='text/javascript' src='test/results/testLongHyphenParseResults.js'></script>" );
        $( "body" ).append( "<script type='text/javascript' src='test/results/testUmlautParseResults.js'></script>" );
    };

    $.ajax( {
        url: "./samples/garbled/underscore-1.4.4.js.gz",
        method: 'get',
        headers: {
            'Content-Encoding': 'gzip, deflate',
            'Accept-Encoding': 'gzip, deflate'
        },
        success: function( response ) {
            //eval( response );
            //or
            Function( response )(); //prefered.
            _invokeTestResults();
        },
        error: function( response ) {
            console.log( "error " + response );
        }
    } );

} );