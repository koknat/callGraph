// shebang is not used in golang
// /home/utils/go-1.9.4/bin/go run example.go

package main

import "fmt"

func foo() {
    var arg1 string
    arg1 = "a"
    bar(globalList[0])
    bar(arg1)
}
func bar( myList string ) {
    globalRunCount = globalRunCount + 1
    if ( globalRunCount < 2 ) {
        bar(myList)
    }
    fmt.Println("hello")
    baz()
}
func baz() {
    fmt.Println("world %s", globalList[0])
}

// main program
var globalRunCount int
var globalList [2]string
func main() {
    globalRunCount = 0
	globalList[0] = "a"
	globalList[1] = "b"
    foo()
    baz()
}

