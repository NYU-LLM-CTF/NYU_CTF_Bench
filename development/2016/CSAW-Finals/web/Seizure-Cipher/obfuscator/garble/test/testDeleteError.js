window.app = {};

app.delete = function( req, res ) {
    console.log( "testDeleteError pass." );
};

app.delete( '*', function( req, res ) {} );