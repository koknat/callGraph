#!/home/utils/tcl8.4.20/bin/tclsh8.4
proc big { arg1 arg2 arg3 {arg4 "defaultval"} } {
    global a b 
    global c d \
    e f \
    g h
    #comment
    set g $h
    set ::x "X"
    foo
}
proc foo { {arg5 "defaultval"} } {
    global i
    puts "hello"
    bar $arg5
    set ::y "Y"
}
proc bar { arg6 } {
    global j
    puts "world $arg6"
    set ::z "Z"
}
proc d {args} {}
set h "hello"
set baz [big "a" "b" "c"]
puts $baz
bar

#proc old { arg7 } {
#    # This old code is no longer used
#    puts "world $arg7 $::w"
#    bar
#}
#old();
