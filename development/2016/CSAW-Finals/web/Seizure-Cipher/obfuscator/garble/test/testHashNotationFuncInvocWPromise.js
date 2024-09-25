function Op1( resolve ) {
    resolve();
}

function Op2() {
    throw new Error( 'Catch the error' );
}

new Promise( Op1 ).
then( Op2 )[ 'catch' ]( function( err ) {
    console.log( "testHashNotationFuncInvocWPromise Condition 1 pass" );
} );

new Promise( Op1 ).
then( Op2 ).catch( function( err ) {
    console.log( "testHashNotationFuncInvocWPromise Condition 2 pass" );
} );