#! /usr/bin/perl -w
use strict;
 use Term::ANSIColor qw(:constants);
use Math::Round;

# JudgmentalSoft #

system("clear");

my @families = ` ls BatchControl/ `;

#print "@families\n";

for(my $i=0; $i<@families; $i++) {
chomp $families[$i];

print RED, $families[$i], RESET, "\t";

my $residual = (split(' ', ` grep ' residual' BatchControl/$families[$i]/step14.out ` ))[2];
if( $residual ) {  } else { $residual = 0.5; }

print BLUE, $residual, RESET, "\t";

my $dup=0;
if( $residual > 0.1 ) { print '*DUP*', "\t"; $dup=1; }  else { print "\t"; }

my @mu = split(' ', ` grep -m 1 -A 1 'mu' BatchControl/$families[$i]/step14.out | tail -n 1 ` );
shift @mu;

if( $mu[0] > $mu[1] ) { push @mu, $mu[0]; shift @mu; }

$mu[0] = round($mu[0]);
$mu[1] = round($mu[1]);

print "@mu\t";

print ($mu[0] & 1 ? "odd" : "even");
print "\t";
print ($mu[1] & 1 ? "odd" : "even");
print "\t";

if ( $mu[0] % 2 == 0 and $mu[1] % 2 == 1 ) { # even, odd
$mu[1] = 2*$mu[0];
goto die1;
}

if ( $mu[0] % 2 == 1 and $mu[1] % 2 == 0 and $dup==0 ) { # odd,even
shift @mu;
shift @mu;
goto die1;
}

if ( $mu[0] % 2 == 0 and $mu[1] % 2 == 0 and $mu[1] % $mu[0])  { # odd,even, and does not divide cleanly
$mu[1] = 2*$mu[0];
goto die1;
}

#if ($num % $divisor) {
#    # does not divide cleanly
#} else {
#    # does.
#}

die1:
print "@mu";

if($mu[0] and $mu[1] and 3*$mu[0] == $mu[1]) {
print "\t", '*TRIPLICATION*';
}

if($mu[0] and $mu[1]) {} else {
print "\t", '*NOT DUPLICATED*';
}

print "\n";

#####################################################################

my @tree = ` grep '___' BatchControl/$families[$i]/step8.out ` ;

#print "@tree\n";

for(my $j=0; $j<@tree; $j++) {
chomp $tree[$j];
my $tree_line = (split(' ', $tree[$j]))[1];
print $tree_line, "\n";
}

print "\n";

#####################################################################

}

exit;

