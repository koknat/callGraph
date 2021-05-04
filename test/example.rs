fn foo() {
    let arg1 = "a";
    bar(arg1);
}
fn bar( myList: String ) {
    if (0) {
        bar(myList);
    }
    println!("hello");
    baz();
}
pub fn baz() {
    println!("world");
}

// main program
fun main(args: Array<String>) {
    foo();
    baz();
}

// To compile:
//     (haven't tried)
