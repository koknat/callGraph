#!/usr/bin/env ruby

def foo()
    arg1 = 'a'
    bar($globalList)
end

def bar( myList )
    $globalRunCount = $globalRunCount + 1
    if $globalRunCount < 2
        bar(myList)
    end
    puts("hello")
    baz()
end

def baz
    puts("world %s" % $globalList)
end

# main program
$globalRunCount = 0
$globalList = ['a', 'b']
foo()
baz()
exit(0)

