% TODO try running this on a basic interpreter

DECLARE SUB foo
DECLARE SUB bar
DECLARE SUB baz

FUNCTION foo ()
    arg1$ = "a"
    CALL bar(globalList)
END FUNCTION

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
