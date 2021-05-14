private def foo = {
    var arg1 = "a"
    bar(arg1)
}
def bar( myList ) = {
    if (0) {
        bar(myList)
    }
    println("hello");
    baz()
}
def baz = {
    println("world")
}

foo()
baz()

