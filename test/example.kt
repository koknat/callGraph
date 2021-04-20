fun foo() {
    val arg1 = "a";
    bar(arg1);
}
fun bar( myList: String ) {
    if (0) {
        bar(myList);
    }
    println("hello");
    baz();
}
fun baz() {
    println("world");
}

// main program
fun main(args: Array<String>) {
    foo();
    baz();
}

// To compile:
//     (haven't tried)
