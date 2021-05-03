#!/home/utils/node-v14.5.0/bin/node
// #!/usr/bin/env node
// Same example for .ts typescript

function foo() {
    arg1 = 'a'
    bar(globalList)
}
function bar( myList ) {
    globalRunCount = globalRunCount + 1
    if ( globalRunCount < 2 ) {
        bar(myList)
    }
    console.log("hello")
    baz()
}
function baz() {
    console.log("world %s", globalList)
}
// main program
globalRunCount = 0
globalList = ['a', 'b']
foo()
baz()

