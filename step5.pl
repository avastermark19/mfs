#!/usr/bin/perl -w
use strict;
  use Term::ANSIColor qw(:constants);

if( -e "STEP7_COMPLETED" ) { print 'Step 5 and 6 not recommended after completing Step7 ', "\n"; }
unless ( -e "STEP7_COMPLETED" ) {

open(OUTPUT, ">step5.out");

# PRECOMPUTE CONS SEQUENCES
my %jobid;

` rm -rf CONS/ `; #??
` mkdir CONS/ `;

my @dir = ` ls CLUSTER `;
for(my $i=0; $i<@dir; $i++) {
chomp $dir[$i];

print OUTPUT '>'.$dir[$i], "\n";

my @Q = split(' ', ` grep '^Q ' CLUSTER/$dir[$i]/HHALIGN/$dir[$i].hhalign | grep -v 'Consensus' `);

for(my $i=6; $i<@Q; $i+=3) { $Q[3] .= $Q[$i]; }

print OUTPUT $Q[3], "\n";

open( FILE,">cons.txt");
print FILE ">seq\n$Q[3]\n";
close(FILE);

my @python = split ( ' ', ` python ~/mfs/topcons2_wsdl.py -m submit -seq cons.txt ` );

$jobid{$dir[$i]} = $python[11];

` rm -f cons.txt `;

}

##############################################################

do {
while (my ($key , $value) = each(%jobid)) {

my @python = split (' ',  ` python ~/mfs/topcons2_wsdl.py -m get -jobid $value `);
if ( $python[6] ne 'not' ) {

` unzip $value.zip `; ` rm -f $value.zip `; ` mv $value CONS/$key ` ;

delete $jobid{$key};
}
}
print STDERR scalar(keys %jobid), " -> ";
} while ( keys %jobid > 0 ); 
print STDERR "\n";
print STDERR 'DONE', "\n";

close(OUTPUT);

}

exit;

