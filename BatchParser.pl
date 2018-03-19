#! /usr/bin/perl -w
use strict;
 use Term::ANSIColor qw(:constants);
use Math::Round;

if($ARGV[0]) {} else { print 'ARGV', "\n"; exit; }

if($ARGV[0] == 1) {
} # THIS MODE WILL CHARACTERIZE ONLY THE STEP14.OUT IN HOME DIRECTORY
# IF YOU DONT WANT TO RUN IN THIS MODE YOU HAVE TO PLACE A  2 (to run all in directory)

if($ARGV[0] == 2) {system("clear");}


my @families;
if( $ARGV[0] != 1) {
 @families = ` ls BatchControl/ `;
}

if( $ARGV[0] == 1) {
push @families, 'step14.out';
}

#print "@families\n";

for(my $i=0; $i<@families; $i++) {
chomp $families[$i];

if( $ARGV[0] != 1 ) {
print RED, $families[$i], RESET, "\t";
}

my $residual;

if( $ARGV[0] != 1 ) {
 $residual = (split(' ', ` grep ' residual' BatchControl/$families[$i]/step14.out ` ))[2];
}

if( $ARGV[0] == 1 ) {
 $residual = (split(' ', ` grep ' residual' step14.out ` ))[2];
}
if( $residual ) {  } else { $residual = 0.5; }

if( $ARGV[0] != 1 ) {
print BLUE, $residual, RESET, "\t";
}

my $dup=0;
if( $residual > 0.1 ) { if($ARGV[0] != 1) {print '*DUP*', "\t";} $dup=1; }  else { if($ARGV[0] != 1) {print "\t";} }

my @mu;
if( $ARGV[0] != 1 ) {
 @mu = split(' ', ` grep -m 1 -A 1 'mu' BatchControl/$families[$i]/step14.out | tail -n 1 ` );
}

if( $ARGV[0] == 1 ) {
 @mu = split(' ', ` grep -m 1 -A 1 'mu' step14.out | tail -n 1 ` );
}

shift @mu;

if( $mu[0] > $mu[1] ) { push @mu, $mu[0]; shift @mu; }

$mu[0] = round($mu[0]);
$mu[1] = round($mu[1]);

if( $ARGV[0] != 1 ) {
print "@mu\t";
print ($mu[0] & 1 ? "odd" : "even");
print "\t";
print ($mu[1] & 1 ? "odd" : "even");
print "\t";
}

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

if( $ARGV[0] != 1 ) {
print "@mu";

if($mu[0] and $mu[1] and 3*$mu[0] == $mu[1]) {
print "\t", '*TRIPLICATION*';
}

if($mu[0] and $mu[1]) {} else {
print "\t", '*NOT DUPLICATED*';
}
}

if( $ARGV[0] == 1 ) {
if( $mu[0] ) { print $mu[0]; }
else { print '5'; } # Generic Repeat Unit
}

print "\n";

#####################################################################
if($ARGV[0] != 1) {

my $mu0=0;
my $mu1=0;
my $mu3=0;

my $mu0ap=0;
my $mu1ap=0;
my $mu3ap=0;

my $F=0;
my $M=0;
my $E=0;

my $F2=0;
my $M2=0;
my $E2=0;

my $string='';
my $string2='';

my @tree = ` grep '___' BatchControl/$families[$i]/step8.out ` ;

#print "@tree\n";

for(my $j=0; $j<@tree; $j++) {
chomp $tree[$j];
my $tree_line = (split(' ', $tree[$j]))[1];
#print $tree_line, "\n";

my $tms = (split( '_', (split(/__/, $tree_line))[0]))[-1];
print $tms, "\t";

my $add='x';
if( $tms ==   $mu[0] ) { $mu0++; $add = 'U'; }
if( $tms ==  2* $mu[0]  ) { $mu1++; $add = 'D'; }
if( $tms == 3*$mu[0] ) { $mu3++; $add ='T'; }
$string .= $add;

#print GREEN, ($tms / $mu[0]) , RESET, "\n";
$add='x';
if( ($tms / $mu[0]) < 1.3 and ($tms / $mu[0]) > 0.7 ) { $mu0ap++; $add = 'U'; }
if( $tms /( 2* $mu[0]) < 1.3 and $tms /( 2* $mu[0]) > 0.7  ) { $mu1ap++; $add = 'D'; }
if( $tms /( 3* $mu[0]) < 1.3 and $tms /( 3* $mu[0]) > 0.7  ) { $mu3ap++; $add = 'T'; }
$string2 .= $add;

my @on_yellow;
if ($tree_line =~ /(-*(abc|a-bc|ab-c)(\w|-)*)/) {
#print ON_YELLOW, $1, RESET, "\n";
 @on_yellow = split('', $1);
}

my $mega_k=0;
my $mega_n=0;
for (my $k=0; $k<@on_yellow; $k++) {
if($on_yellow[$k] eq '-') { $mega_k+= $k; $mega_n++; }
}
if( $mega_n>0) {
#print GREEN, ($mega_k/$mega_n)/(scalar @on_yellow), RESET, "\n";
my $loc = ($mega_k/$mega_n)/(scalar @on_yellow);
if( $loc < 0.33 ) { $F2++; } else {
if( $loc > 0.66 ) { $E2++; } else { $M2++; }
}

}

if ($tree_line =~ /(\d\+\d\+\d\+\d\+\d)/ ) {
my @dist = split(/\+/, $1);
print RED, $dist[0], ' ', $dist[2], ' ', $dist[4], RESET, "\n";
if( $dist[0] > 0 ) { $F++; }
if( $dist[2] > 0 ) { $M++; }
if( $dist[4] > 0 ) { $E++; }
} else { print "\n"; }
}
print "\n";

print 'SINGLE UNITS: ', round(100*$mu0/(scalar @tree)). '-'. round(100*$mu0ap/(scalar @tree)), "% [$mu0-$mu0ap]\n";
print ' DUP   UNITS: ', round(100*$mu1/(scalar @tree)). '-'. round(100*$mu1ap/(scalar @tree)), "%\n";
print ' TRI   UNITS: ', round(100*$mu3/(scalar @tree)). '-'. round(100*$mu3ap/(scalar @tree)),"%\n";
print ' ATYPICALS  : ', 100-round(100*($mu0+$mu1+$mu3)/(scalar @tree)), "%\n";
#print 'N:            ', scalar @tree, "\n";
#print 'F / M / E   : ', round(100*$F/(scalar @tree)). "%".' '.round(100*$M/(scalar @tree)).'% '.round(100*$E/(scalar @tree)), "%\n";
print 'F2/ M2/ E2  : ', $F2, ' ',$M2, ' ', $E2, "\n";
print 'string      : ', $string, "\n";
$string = lc($string);

#` echo "awk -v RS='[a-z]' '{str=(++a[RT]==1?str RT: str)}END{print str}' <<< "$string" " > temp.awk `;
#print 'string3     : ';
#` chmod u+x temp.awk `;
#` ./temp.awk `;

#$string =~ s/(.)(?=.*?\1)//g;
#print 'string      : ', $string, "\n";

print 'RLC         : ';
my $rlc='';
my @sstring = split('', $string);
for(my $l=1; $l<@sstring; $l++) {
if($sstring[$l] ne $sstring[$l-1]) {
$rlc .= $sstring[$l];
}
}
print $rlc;
print "\t", round(100*length($rlc)/length($string)).'%';
print "\n";

print 'string2     : ', lc($string2), "\n";
print "\n";
}

#####################################################################

}

exit;

