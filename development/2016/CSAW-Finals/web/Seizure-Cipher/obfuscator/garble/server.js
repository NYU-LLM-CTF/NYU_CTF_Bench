var express = require( 'express' );
var app = express();

app.configure( function() {
    app.use( function( req, res, next ) {
        var matchUrl = '/samples/garbled/underscore-1.4.4.js.gz';
        if ( req.url === matchUrl ) {
            res.setHeader( "Content-Encoding", "gzip, delfate" );
        }
        return next();
    } );
    app.use( "/", express.static( __dirname ) );
} );

app.listen( 8085 );
console.log( "local application server started on port 8085." );
console.log( "ctrl-c to exit." );