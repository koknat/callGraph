#!/usr/bin/php
<?php

function foo() {
    global $globalList;
    $arg1 = 'a';
    bar($globalList);
}
function bar( $myList ) {
    global $globalRunCount;
    $globalRunCount = $globalRunCount + 1;
    if ( $globalRunCount < 2 ) {
        bar($myList);
    }
    print "hello\n";
    baz();
}
function baz() {
    global $globalList;
    print "world $globalList\n";
}
# main program
$globalRunCount = 0;
$globalList = array('a', 'b');
foo();
baz();
?>
