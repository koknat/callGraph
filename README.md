## callGraph is a multi-language tool which parses source code for function definitions and calls.
It generates a .png call graph and displays it on screen.<br>
The parser was designed for Perl/Python/TCL, and has been extended for other languages.
!["Sample output of Python"](test/regression/example.py.golden.png)
    Usage:
        callGraph  <files>  <options>
        
    Options:
        -start <function>          Specify function(s) as starting point instead of the main code.
                                   These are displayed in green.
                                   This is useful when parsing a large script, as the generated graph can be huge.
                                   In addition, the calls leading to this function are charted.
                                   Functions which are not reachable from one of the starting points are not charted.

        -ignore <regex>            Specify function(s) to ignore.
                                   This is useful when pruning the output of a large graph.
                                   To ignore multiple functions, use this regex format:
                                       -ignore '(abc|xyz)'

        -verbose                   For Perl/TCL, attempts to list the global variables used in each function call in the graph.
                                   Global variables are arguably not the best design paradigm,
                                     but they are found extensively in real-world legacy scripts.

                                   Perl:
                                       'my' variables will affect this determination (use strict).
                                       does not distinguish between $var, @var and %var.

                                   TCL:
                                       variables declared as 'global' but not used, are marked with a '*'
                                       'upvar' is not tracked.

        -language <lang>           By default, filename extensions are parsed for .pl .pm .tcl .py, etc
                                   If those are not found, the first line of the script (#! shebang) is inspected.
                                   If neither of those give clues, use this option to specify 'pl' or 'tcl' or 'py'.

        -output <filename>         Specify an output filename
                                   By default, the .png file is named according to the first filename.
                                   If a filename ending in .dot is given, only the intermediate .dot file is created.

        -writeSubsetCode <file>    Create an output source file which includes only the subroutines included in the graph.
                                   This can be useful when trying to comprehend a large set of legacy code.

        -noShow                    By default, the png file is displayed.  This option prevents that behavior.

        -fullPath                  By default, the script strips off the path name of the input file(s).
                                   This option prevents that behavior.

    Usage examples:
        callGraph  example.pl example_helper_lib.pm
        callGraph  example.py
        callGraph  example.tcl
        callGraph  example.tcl -verbose

    Caveats:
        This is not a true Perl or Python or TCL parser.  Far from it!
        It uses a simple line-by-line algorithm, using regexes to find function calls.
        As such, the formatting must be regular, and don't expect miracles, such as parsing dynamic function calls.
        For example:
            Perl subroutines must start with /sub <name>/ and end with /}/
            Python functions must start with /def <name>:/
            TCL procedures must start with /proc <name>/ and end with /}/
            Spaces may exist at the beginning of these lines, but they must be equal in number.
            If your Perl script does not follow this rule, consider running it through perltidy first.
       
    Notes:
        Caveats aside, it seems to work well on garden-variety scripts spanning tens of thousands of lines,
            and has helped me unravel large pieces of legacy code to implement urgent bug fixes.
        It should also work on many other languages, such as:
            awk, fortran, go, lua, java, javascript, pascal, php, r, raku, ruby, and swift,
            but those have not been well tested.
        
    Acknowlegements:
        This code utilizes core functionality from perl_call_graph.pl by Stephen Riehm s.riehm@opensauce.de

    Requirements:
        GraphViz and the Perl GraphViz library must be installed:
            sudo apt-get install graphviz
            sudo cpan install GraphViz
