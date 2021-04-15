#!/usr/bin/awk -f

function foo() {
    $arg1 = "a"
    bar($globalList[1])
}
function bar(myList) {
    $globalRunCount = $globalRunCount + 1
    if ( $globalRunCount < 2 ) {
        bar($myList)
    }
    print "hello\n"
    baz()
}
function baz() {
    print "world $globalList[1]\n"
}
# main program
globalRunCount = 0
globalList[1] = "a"
globalList[2] = "b"
foo()
baz()
