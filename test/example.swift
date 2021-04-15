func foo() {
    let arg1 = "a"
    bar(myList: globalList[0])
    bar(myList: arg1)
}
func bar( myList: String ) {
    globalRunCount += 1
    if ( globalRunCount < 2 ) {
        bar(myList: myList)
    }
    print("hello")
    baz()
}
func baz() {
    print("world %s", globalList[0])
}

// main program
var globalRunCount: Int
var globalList: [String]
globalRunCount = 0
globalList = ["a", "b"]
foo()
baz()

// To compile:
//     swiftc example.swift
