#!/bin/bash
echo "garbling sample libraries"
function generateGarbleResults() {
    rm -rf "samples/garbled"
    rm -rf "test/results"
    mkdir "samples/garbled"
    mkdir "test/results"
    cd src
        python garble.py "..\samples\angular-1.0.4.js" "..\samples\garbled\angular-1.0.4.js" no
        python garble.py "..\samples\jquery-1.9.1.js" "..\samples\garbled\jquery-1.9.1.js" no
        python garble.py "..\samples\underscore-1.4.4.js" "..\samples\garbled\underscore-1.4.4.js" no
        python garble.py "..\samples\angular-1.0.4.js" "..\samples\garbled\angular-1.0.4.js" yes
        python garble.py "..\samples\jquery-1.9.1.js" "..\samples\garbled\jquery-1.9.1.js" yes
        python garble.py "..\samples\underscore-1.4.4.js" "..\samples\garbled\underscore-1.4.4.js" yes
            echo "garbling sample libraries completed"
            echo "garbling tests"
                python garble.py "..\test\testDeleteError.js" "..\test\results\testDeleteErrorResults.js" no
                python garble.py "..\test\testHashNotationFuncInvocWPromise.js" "..\test\results\testHashNotationFuncInvocWPromiseResults.js" no
                python garble.py "..\test\testHashNotationFunctionInvocation.js" "..\test\results\testHashNotationFunctionInvocationResults.js" no
                python garble.py "..\test\testLongHyphenParse.js" "..\test\results\testLongHyphenParseResults.js" no
                python garble.py "..\test\testUmlautParse.js" "..\test\results\testUmlautParseResults.js" no
                python garble.py "..\test\testDeleteError.js" "..\test\results\testDeleteErrorResults.js" yes
                python garble.py "..\test\testHashNotationFuncInvocWPromise.js" "..\test\results\testHashNotationFuncInvocWPromiseResults.js" yes
                python garble.py "..\test\testHashNotationFunctionInvocation.js" "..\test\results\testHashNotationFunctionInvocationResults.js" yes
                python garble.py "..\test\testLongHyphenParse.js" "..\test\results\testLongHyphenParseResults.js" yes
                python garble.py "..\test\testUmlautParse.js" "..\test\results\testUmlautParseResults.js" yes
                echo "gabling tests completed"
                    cd ..
}
generateGarbleResults
echo "done"