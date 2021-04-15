class example {
    public static void foo() {
        String[] arg1 = {"a"};
        bar(arg1);
    }
    public static void bar( String[] myList ) {
        bar(myList);
        System.out.printf("hello");
        baz();
    }
    public static void baz() {
        System.out.printf("world");
    }

    // main program
    public static void main(String[] args) {
        foo();
        baz();
    }
}

// To compile:
//     rm example.class ; javac example.java ; ls -l example.java example.class ; java example
