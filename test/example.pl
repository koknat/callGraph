#!/usr/bin/perl
use FindBin;
use lib "$FindBin::Bin";
use example_helper_lib;
sub say { print @_, "\n" };
sub foo {
    my ($arg1, $arg2, $arg3, @arg4) = @_;
    $arg1 =~ s#aaa#bbb#g;
    #comment
    bar(@globalArray);
    example_helper_lib::abc();
}
sub bar {
    my (%arg5, $arg7);
    $globalRunCount++;
    bar() unless $globalRunCount >= 2;
    print "hello $arg7 @globalArray\n";
    baz(\%arg5);
}
sub baz {
    # Uses no globals
    my @arg6;
    # @arg6 = @globalArray;  # commented out purposely
    chomp(my $arg7 = length(@arg6));
    say "world ${arg2} @arg6";
}
sub old1 {
    # This old code is no longer used, nothing calls it, and it calls nothing
    my $arg8 = 'zzz';
}
# main program
my $globalRunCount = 0;
my @globalArray = ( 'red', 'blue' );
my $result = foo("a", "b", "c", "xyz");
baz();
print "$result\n";
exit 0;

# commented code
# my $globalVarCommented2
# old2();
# sub old2 {
#     # This old code is no longer used
#     my $qux;
#     $globalRunCount++;
# }

__END__

my $globalVarCommented2;
old3();
sub old3 {
    # This old code is no longer used
    my $quxx;
    push @globalArray, 'green';
}
