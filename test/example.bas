% TODO try running this on a basic interpreter

DECLARE SUB foo
DECLARE SUB bar
DECLARE SUB baz

SUB foo ()
    arg1$ = "a"
    CALL bar(globalList)
END SUB

SUB bar (myList)
    globalRunCount = globalRunCount + 1
    if globalRunCount < 2 THEN
        CALL bar(myList)
    END IF
    PRINT "hello"
    CALL baz()
END SUB

SUB baz()
    PRINT "world "; globalList$
END SUB

REM main program
globalRunCount$ = 0
DIM globalList(2) as String
globalList(1) = "a"
globalList(2) = "b"
CALL foo()
CALL baz()
