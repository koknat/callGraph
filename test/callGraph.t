#!/usr/bin/perl
# #!/home/utils/perl-5.8.8/bin/perl
use warnings;
use strict;
use File::Basename qw(basename dirname);
use File::Temp qw(tempdir);
use Getopt::Long;
use Test::More qw( no_plan );    # 5.8.1 or newer
$SIG{__WARN__} = sub { die @_ }; # die instead of produce warnings
sub say { print @_, "\n" }
sub D   { say "Debug::Statements has been disabled" }
sub d   { }
sub d2  { }
sub ls  { }
#use lib "/home/ate/scripts/regression";
#use Debug::Statements;

# This should be run from the callGraph/test directory
# perl callGraph.t

# Parse options
my %opt;
my $d = 0;
GetOptions( \%opt, 'test|t=s', 'd' => sub { $d = 1 }, 'die' ) or die $!;
my $t = defined $opt{test} ? $opt{test} : 'ALL';
die "ERROR:  Did not expect '@ARGV'.  Did you forget '-t' ? " if @ARGV;

chomp( my $pwd = `pwd` );
my $script = 'callGraph';
my $executable;       # callGraph executable
my $testDir;          # callGraph/test directory
my $regressionDir;    # callGraph/test/regression directory
if ( $pwd =~ m{/$script(-master.*)?/test$} ) {
    $executable    = dirname($pwd) . "/$script";
    $testDir       = "$pwd";
    $regressionDir = "$pwd/regression";
} elsif ( $pwd =~ m{/$script(-master)?$} ) {
    $executable    = "$pwd/$script";
    $testDir       = "$pwd/test";
    $regressionDir = "$pwd/test/regression";
} else {
    die "ERROR:  This must be run from the $script/test directory!\n";
}
die "ERROR:  executable not found:  $executable" unless -e $executable;
chomp( my $whoami = `whoami` );
if ( $whoami eq 'ckoknat' ) {
    $executable = "/home/utils/perl-5.8.8/bin/perl $executable";
}
#say "\$pwd = $pwd";
#say "\$executable = $executable";
#say "\$testDir = $testDir";

my $pass = 0;
my $fail = 256;
my $err  = 512;
print "\n\n\n\n";
my $globaltmpdir = tempdir( "/tmp/${script}_XXXX", CLEANUP => 0 );
chdir($testDir);
my $separator = "\n###\n";

eval 'use GraphViz ()';
if ($@) {
    say "ERROR:  Install GraphViz and the CPAN GraphViz module to create the call graph";
    say "        sudo apt-get install Graphviz";
    say "        and";
    say "        sudo cpan install GraphViz";
    exit 1;
}

my $format = 'png';
say $separator;
if ( runtests('pl') ) {
    runDot( "$testDir/example.pl $testDir/example_helper_lib.pm", "-noShow", "$regressionDir/example.pl.dot" );    # .dot creation instead of .png
    runCmpFiles( "$testDir/example.pl $testDir/example_helper_lib.pm", "-n -r -v -fullpath -ignore say", "$regressionDir/example.pl.$format" );
}
if ( runtests('other') ) {
    # Missing .for .lua .pas
    for my $language (qw( awk bas go js kt m php r rb rs py sh swift tcl )) {
        say $separator;
        runCmpFiles( "$testDir/example.$language", "-n -r -v", "$regressionDir/example.$language.$format" );
    }
}

# Print pass/fail summary
my $num_failed = summary();
d '$num_failed';
if ( $whoami eq 'ckoknat' ) {
    if ( !defined $opt{test} and !$num_failed ) {
        say "\nIf everything passes do this:";
        say "    ~/r/$script/test2/${script}2.t\n";
    }
}

exit 0;

sub runCmpFiles {
    my ( $sourceFiles, $options, $output ) = @_;
    d '$sourceFiles $options $output';
    ( my $baseScript = $executable ) =~ s/.* (\S+)$/$1/;
    $baseScript = basename($executable);
    my $stdout = "regression__${baseScript}__${sourceFiles}__${options}";
    $stdout =~ s/[\s'"\(\)\{\}\$\@\%\/\|=]/_/g;
    $stdout .= '.stdout';
    $stdout = $regressionDir . '/' . $stdout;
    my $dot;

    if ( defined $output ) {
        ( $dot = $output ) =~ s/\.png$/.dot/;
    } else {
        ( $dot = $sourceFiles ) =~ s/^(\S+).*/$1/;    # Use the first filename
        $dot = $regressionDir . '/' . basename($dot) . '.dot';
    }
    d '$dot $stdout';
    runDot( $sourceFiles, "$options > $stdout", $output );
    ls "$dot $stdout";
    # Compare dot to goldens
    if ( $whoami eq 'ckoknat' ) {
        # Compare stdout to goldens
        # This is not done because dot files differ somewhat, based on the Perl version
        testCmpFiles( {}, to_from_golden($dot), $dot, undef, undef, undef, undef );
        # This is not done for other users, because of path names
        testCmpFiles( {}, to_from_golden($stdout), $stdout, "!\\d+.*$output", undef, undef, undef );
    }
}

# Ensure the .dot is created and filesize > N
sub runDot {
    my ( $sourceFiles, $options, $output ) = @_;
    d '$sourceFiles $options $output';
    my ( $cmd, $result, $expected );

    # Normal run
    $cmd = "$executable $sourceFiles";
    $cmd .= " -output $output" if defined $output;
    $cmd .= " $options";    # options may contain "> file"
    d '$cmd';
    if ( !defined $output ) {
        ( $output = $sourceFiles ) =~ s/^(\S+).*/$1/;    # Use the first filename
        $output = basename($output) . '.png';
    }
    `rm $output` if -f $output;
    chomp( $result = `$cmd` );
    d '$result';
    ls $output;
    is( -f $output, 1, "'$cmd' created file $output" );
    my $minFileSize;
    if ( $output =~ /\.dot$/ ) {
        $minFileSize = 500;
    } else {
        $minFileSize = 4000;
    }
    my $fileSize = -s $output;
    is( $fileSize > $minFileSize, 1, "Size of $output ($fileSize) is > $minFileSize" );
}

# Controls running of test suites (a test suite is a set of tests)
sub runtests {
    my $testgroup = shift;
    # $t is specifed on the command line with -t
    #     it is either
    #     -t <testgroup>
    #     or
    #     -t <regex>
    #     or
    #     -t ALL  or  no -t specified on command line
    #
    # .t contains blocks such as these, each passing $testgroup to runtests():
    #     if ( runtests('yaml') ) {}
    #     if ( runtests('yaml|json') ) {}
    #
    # If the regex is followed by '+', then run that test and all tests following it
    #
    my $d       = 0;     # 1 = debug statements for runtests()
    my $local_t = $t;    # for debug statement
    if ( $t =~ /^($testgroup|ALL)?(\+)*$/ ) {
        my ( $t_regex, $plus ) = ( $1, $2, $3 );
        d '$testgroup $local_t $t_regex $plus';
        print "\n*** $testgroup ***\n";
        if ($plus) {
            $t = 'ALL';
        }
        return 1;
    } else {
        return 0;
    }
}

sub summary {
    # Print message if any test failed
    my ($href) = @_;
    my ( $passed, $failed ) = ( 0, 0 );
    my @tests = Test::More->builder->details;
    my @failed;
    my $i = 0;
    for my $test (@tests) {
        $i++;
        if   ( $test->{ok} ) { $passed++ }
        else                 { $failed++; push @failed, $i }
    }
    my $message;
    if ( $passed == 0 && $failed == 0 ) {
        $message = "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! no tests run !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
    } elsif ($failed) {
        $message = "\n################################ tests " . ( join " ", @failed ) . " FAILED ################################\n";
    } else {
        $message = "\n################################ all tests passed ################################\n";
    }
    #done_testing(); # TODO uncomment?
    print $message;
    return $failed;
}

sub to_from_golden {
    my ( $file, $extension ) = @_;
    $extension = 'golden' if !defined $extension;
    my ( $goldfile, $position );
    my $dirname = dirname($file);
    my $bfile   = basename($file);
    if ( $bfile =~ /^(.*)\.$extension(.*)$/ ) {
        # a.golden     => a
        # a.golden.csv => a.csv
        # returning the NON golden filename
        d 1;
        $goldfile = "$1$2";
        $position = 2;
    } elsif ( $bfile =~ /^(.*)(\.[^.]+)$/ ) {
        # a.csv        => a.golden.csv
        # returning the golden filename
        d 2;
        $goldfile = "$1.$extension$2";
        $position = 1;
    } else {
        # a            => a.golden
        # returning the golden filename
        d 3;
        $goldfile = "$bfile.$extension";
        $position = 1;
    }
    my $result;
    if ( $dirname eq '.' ) {
        $result = $goldfile;
    } else {
        $result = "$dirname/$goldfile";
    }
    d '$bfile $dirname $goldfile $result';
    return $result;
    #return wantarray ? ($result, $position) : $result;
}

# From regression/runCmdTest.pm
# Compare contents of two files (in this case, an output file vs the golden output)
# If $regex is present, only compare lines which match the regex
# If $regex starts with '!', remove the '!' and negate (invert) the regex
# Optionally sort the output before comparing
# By default, the output should have nonzero size after grepping with the regex
# testfile($file1, $file2, $regex, $sort, $emptyOK);
sub testCmpFiles {
    my ( $self, $file1, $file2, $regex, $sort, $emptyOK, $substitute ) = @_;
    my $d = $self->{debug};
    $sort    = 0 if !defined $sort;
    $emptyOK = 0 if !defined $emptyOK;
    d('$file1 $file2 $regex $sort');
    ls "$file1 $file2";
    ok( -e $file1, "File 1 $file1 found" );
    return if !-e $file1;
    ok( -e $file2, "File 2 $file2 found" );
    return if !-e $file2;
    my $negate;
    $regex = '' if !defined $regex;

    if ( $regex ne '' and !ref($regex) and index( $regex, '!' ) == 0 ) {
        $negate = 1;
        $regex = substr( $regex, 1, );
        d('$regex');
    }
    d('$negate');
    my $description = "is_deeply diff $file1 $file2";
    $description .= " sorted" if $sort;
    $description .= " !"      if $negate;
    $regex = [$regex] if !ref($regex);
    for my $reg (@$regex) {
        d('$reg');
        $description .= " $reg";
        #my @lines1 = io($file1)->chomp->slurp;
        #my @lines2 = io($file2)->chomp->slurp;
        open my $fh1, '<', $file1;
        chomp( my @lines1 = <$fh1> );
        close $fh1;
        open my $fh2, '<', $file2;
        chomp( my @lines2 = <$fh2> );
        close $fh2;
        d('@lines1 @lines2');

        if ($sort) {
            d('Sorting');
            @lines1 = sort @lines1;
            @lines2 = sort @lines2;
            d('@lines1 @lines2');
        }
        if ($substitute) {
            d('Substituting');
            if ( $substitute =~ /(.+)\^\^(.*)/ ) {
                my ( $search, $replace ) = ( $1, $2 );
                d '$search $replace';
                @lines1 = map { s/$search/$replace/; $_ } @lines1;
                @lines2 = map { s/$search/$replace/; $_ } @lines2;
            } else {
                die "For substitute option, need to have ^^ between search and replace terms\n";
            }
            d('@lines1 @lines2');
        }
        if ($negate) {
            d("Grepping for ! $reg");
            @lines1 = grep { !m/$reg/ } @lines1;
            @lines2 = grep { !m/$reg/ } @lines2;
        } else {
            d("Grepping for $reg");
            @lines1 = grep { m/$reg/ } @lines1;
            @lines2 = grep { m/$reg/ } @lines2;
        }
        d('@lines1 @lines2');
        if ( !$emptyOK and $reg ne '' ) {
            my @empty = ();
            d('@empty');
            die if !isnt( \@lines1, [], "$file1 cannot be empty after grepping for $reg" ) and $self->{die};
            die if !isnt( \@lines2, [], "$file2 cannot be empty after grepping for $reg" ) and $self->{die};
        }
        die if !is_deeply( \@lines1, \@lines2, $description ) and $self->{die};
    }
}

__END__

__END__

callGraph by Chris Koknat  https://github.com/koknat/callGraph
v18 Tue Apr 27 10:51:07 PDT 2021


This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details:
<http://www.gnu.org/licenses/gpl.txt>

