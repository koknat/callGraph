void foo() {
    var arg1 = "a"
    bar(globalList[0])
    bar(arg1)
}
void bar(myList) {
    globalRunCount += 1
    if ( globalRunCount < 2 ) {
        bar(myList)
    }
    print("hello")
    baz()
}
void baz() {
    print("world %s", globalList[0])
}

// main program
main() {
    var globalRunCount = 0
    var globalList = ["a", "b"]
    foo()
    baz()
}
