#!/usr/bin/python

def foo():
    arg1 = 'a'
    bar(globalList)

def bar( myList ):
    global globalRunCount
    globalRunCount = globalRunCount + 1
    if globalRunCount < 2:
        bar(myList)
    print("hello")
    baz()
def baz():
    # intentionally put no space above this def
    print("world %s" % globalList)

# main program
globalRunCount = 0
globalList = ['a', 'b']
foo()
baz()
exit(0)

