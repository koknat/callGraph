## A multi-language tool to parse source code for function definitions and calls
callGraph statically generates a call graph image and displays it on screen<br>
Supported languages are: awk, bash, basic, fortran, go, lua, javascript, kotlin, matlab, perl, pascal, php, python, R, raku, ruby, rust, swift, and tcl.<br>
C/C++/Java are not supported, since their complicated syntax requires a real parser.<br>
!["Sample output of Python"](test/regression/example.py.golden.svg)

    'callGraph' by Chris Koknat

    Usage:
        callGraph  <files>  <options>
        
    Options:
        -language <lang>           By default, filename extensions are parsed for .pl .pm .tcl .py, etc
                                   If those are not found, the first line of the script (#! shebang) is inspected.
                                   If neither of those give clues, use this option to specify 'pl' or 'tcl' or 'py'.

        -start <function>          Specify function(s) as starting point instead of the main code.
                                   These are displayed in green.
                                   This is useful when parsing a large script, as the generated graph can be huge.
                                   In addition, the calls leading to this function are charted.
                                   Functions which are not reachable from one of the starting points are not charted.

        -ignore <regex>            Specify function(s) to ignore.
                                   This is useful when pruning the output of a large graph.
                                   To ignore multiple functions, use this regex format:
                                       -ignore '(abc|xyz)'

        -output <filename>         Specify an output filename
                                   By default, the .png file is named according to the first filename.
                                   If a filename ending in .dot is given, only the intermediate .dot file is created.
                                   If a filename ending in .svg is given, svg format is used

        -noShow                    By default, the .png file is displayed.  This option prevents that behavior.

        -fullPath                  By default, the script strips off the path name of the input file(s).
                                   This option prevents that behavior.

        -writeSubsetCode <file>    Create an output source file which includes only the subroutines included in the graph.
                                   This can be useful when trying to comprehend a large set of legacy code.

        -verbose                   For Perl/TCL, attempts to list the global variables used in each function call in the graph.
                                   Global variables are arguably not the best design paradigm,
                                     but they are found extensively in real-world legacy scripts.

                                   Perl:
                                       'my' variables will affect this determination (use strict).
                                       does not distinguish between $var, @var and %var.

                                   TCL:
                                       variables declared as 'global' but not used, are marked with a '*'


    Usage examples:
        callGraph  example.pl example_helper_lib.pm
        callGraph  example.py
        callGraph  example.tcl
        callGraph  example.tcl -verbose

    Algorithm:
        callGraph uses a simple line-by-line algorithm, using regexes to find function definitions and calls.
        Function definitions can be detected easily, since they start with identifiers such as:
            'sub', 'def', 'proc', 'function', 'func', 'fun', or 'fn'
        Function definitions end with '}' or 'end' at the same nesting level as the definition.
        Function calls are a bit more tricky, since built-in function calls look exactly like user function calls.
            To solve this, the algorithm first assumes that anything matching 'word()' is a function call,
            and then discards any calls which do not have corresponding definitions.
        For example, Perl:
            sub funcA {
                ...
                if ($x) {
                    print($y);
                    funcB($y);
                }
                ...
            }
            sub funcB {
                ...
            }
        Since this is not a true parser, the formatting must be consistent so that nesting can be determined.
        If your Perl script does not follow this rule, consider running it through 'perltidy' first.
        Also, don't expect miracles such as parsing dynamic function calls.
        Caveats aside, it seems to work well on garden-variety scripts spanning tens of thousands of lines,
            and has helped me unravel large pieces of legacy code to implement urgent bug fixes.
        
    Acknowlegements:
        This code utilizes core functionality from https://github.com/cobber/perl_call_graph

    Requirements:
        GraphViz and the Perl GraphViz library must be installed:
            sudo apt-get install graphviz
            sudo cpan install GraphViz
