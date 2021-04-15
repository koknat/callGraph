#include <iostream>
using namespace std;

void baz() {
    cout << "World";
}
void bar( string myList ) {
    bar(myList);
    cout << "Hello";
    baz();
}
void foo() {
    string arg1 = "a";
    bar(arg1);
}

// main program
int main(int argc, char *argv[]) {
    foo();
    baz();
}

// To compile:
//     e10 ; g++ example.cpp -o /tmp/example.out
