#include <iostream>
using namespace std;

void baz() {
    cout << "World\n";
}
void bar( string myList ) {
    if (0) {
        bar(myList);
    }
    cout << "Hello\n";
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
