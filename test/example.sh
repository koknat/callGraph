#!/bin/sh

baz() {
    echo "world ${globalList[1]}"
}
function bar {
    myList=$1
    globalRunCount=$(expr $globalRunCount + 1)
    if [[ $globalRunCount -lt 2 ]]; then
        bar $myList
        echo "a"
    fi
    echo "hello"
    baz
}
foo() {
    arg1="a"
    bar ${globalList[1]}
}
# main program
globalRunCount=0
globalList=(a b)
foo
baz
