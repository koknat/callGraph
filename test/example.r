# TODO try running this

foo <- function() {
    arg1 = "a"
    bar(globalList[1])
}
bar <- function(myList) {
    globalRunCount = globalRunCount + 1
    if ( globalRunCount < 2 ) {
        bar(myList)
    }
    print("hello\n")
    baz()
}
baz <- function() {
    printf("world %s\n", globalList[1])
}
# main program
globalRunCount = 0
globalList <- list("a", "b")
foo()
baz()
