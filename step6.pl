#! /usr/bin/perl -w
use strict;
  use Term::ANSIColor qw(:constants);

if( -e "STEP7_COMPLETED" ) { print 'Step 5 and 6 not recommended after completing Step7 ', "\n"; }
unless ( -e "STEP7_COMPLETED" ) {

#PARAMETERS
my $length = upcase_in(5); # 12;
#########################################################################
my @alpha = ('a','b','c','d','e','f','g','h','i', 'j','k','l', 'm','n','o');

my @dir = ` ls CLUSTER `;

#for(my $i=1; $i<@dir; $i++) {
for(my $i=0; $i<@dir; $i++) {
chomp $dir[$i];

for(my $j=0; $j<@dir; $j++) {
chomp $dir[$j];

#########################################################################
print $dir[$i], ' ', $dir[$j], "\n";

# Perform anti-ss_dssp error check

my @test = split("\n", ` grep 'ss_dssp' CLUSTER/$dir[$i]/HHALIGN/$dir[$j].hhalign `);
#print ON_RED, scalar @test, RESET, "\n";
if  (scalar @test > 0) {
#print 'ERROR', "\n";
print "???\n???\n\n";
} else {

#########################################################################

my @Q = split(' ', ` grep '^Q ' CLUSTER/$dir[$i]/HHALIGN/$dir[$j].hhalign | grep -v 'Consensus' `);
my @T = split(' ', ` grep '^T ' CLUSTER/$dir[$i]/HHALIGN/$dir[$j].hhalign | grep -v 'Consensus' `);


#print $dir[$i], ' ', $dir[$j], "\n";

if( scalar @Q > $length ) {

#print RED, "@Q", RESET, "\n";
#print BLUE, "@T", RESET, "\n";

my @overhang; $overhang[0] = $Q[2]-1; $Q[-1] =~ s/\(|\)//g; $overhang[1] = $Q[-1] - $Q[-2]; $overhang[2] = $T[2]-1; $T[-1] =~ s/\(|\)//g; $overhang[3] = $T[-1] - $T[-2];

for(my $loop=6; $loop<@Q; $loop+=3) { $Q[3] .= $Q[$loop]; $T[3] .= $T[$loop];   }

#print $dir[$i], ' ', $dir[$j], "\n";
#print STDERR $Q[3], "\n";
#print STDERR $T[3], "\n";

my @TOPCONS_Q = split('',    ` grep -A 1 '^TOPCONS '     CONS/$dir[$i]/seq_0/query.result.txt | tail -n 1 `);  pop @TOPCONS_Q;
my @TOPCONS_T = split('',    ` grep -A 1 '^TOPCONS '     CONS/$dir[$j]/seq_0/query.result.txt | tail -n 1 `);  pop @TOPCONS_T;

#########################################################################

#########################################################################

my $counter = -1; for(my $loop=0; $loop<@TOPCONS_Q; $loop++) { if ($TOPCONS_Q[$loop] eq 'S' or $TOPCONS_Q[$loop] eq 'i' or $TOPCONS_Q[$loop] eq 'o' ) { $TOPCONS_Q[$loop] = '-'; } if ( $loop>0 and $TOPCONS_Q[$loop] eq 'M' and $TOPCONS_Q[$loop-1] eq '-' ) { $counter++; } if ( $TOPCONS_Q[$loop] eq 'M' ) { $TOPCONS_Q[$loop] = $alpha[$counter]; } }

   $counter = -1; for(my $loop=0; $loop<@TOPCONS_T; $loop++) { if ($TOPCONS_T[$loop] eq 'S' or $TOPCONS_T[$loop] eq 'i' or $TOPCONS_T[$loop] eq 'o' ) { $TOPCONS_T[$loop] = '-'; } if ( $loop>0 and $TOPCONS_T[$loop] eq 'M' and $TOPCONS_T[$loop-1] eq '-' ) { $counter++; } if ( $TOPCONS_T[$loop] eq 'M' ) { $TOPCONS_T[$loop] = $alpha[$counter]; } }

#print scalar @TOPCONS_Q, "\n";
#print  @TOPCONS_Q, "\n";
#print scalar @TOPCONS_T, "\n";
#print  @TOPCONS_T, "\n";
#print  "@overhang\n";

##################################################################################################################################################
# RECONSTRUCT OVERHANG

my @split_Q = split('', $Q[3] ); 
for(my $loop=0; $loop<@split_Q; $loop++) { 
if( $split_Q[$loop] eq '-' ) {
if( $loop+$overhang[0] <= @TOPCONS_Q ) {
splice @TOPCONS_Q, $loop+$overhang[0], 0, '-'; 
}
}
}

my @split_T = split('', $T[3] );
for(my $loop=0; $loop<@split_T; $loop++) {
if( $split_T[$loop] eq '-' ) {
if( $loop+$overhang[2] <= @TOPCONS_T ) {
splice @TOPCONS_T, $loop+$overhang[2], 0, '-';
}
}
}

for(my $loop=0; $loop<$overhang[0]; $loop++) {  unshift @TOPCONS_T, '-'; }
for(my $loop=0; $loop<$overhang[1]; $loop++) {  push @TOPCONS_T, '-'; }
for(my $loop=0; $loop<$overhang[2]; $loop++) {  unshift @TOPCONS_Q, '-'; }
for(my $loop=0; $loop<$overhang[3]; $loop++) {  push @TOPCONS_Q, '-'; }

#print STDERR @TOPCONS_Q, "\n";
#print STDERR @TOPCONS_T, "\n";


##################################################################################################################################################

my %pairing;

for(my $loop=0; $loop< @TOPCONS_Q; $loop++) { if ( $TOPCONS_T[$loop]     )  { $pairing{$TOPCONS_Q[$loop].'_'.$TOPCONS_T[$loop]}++; } }

for(my $loop=0; $loop< @TOPCONS_T; $loop++) { if ( $TOPCONS_Q[$loop]     )  { $pairing{$TOPCONS_Q[$loop].'_'.$TOPCONS_T[$loop]}++; } }

while (my ($key, $value) = each(%pairing)) { if( $value < 20 ) { delete $pairing{$key}; } }

while (my ($key, $value) = each(%pairing)) { 
# print $key, ' ', $value, "\n"; 
 }

$#Q = -1;    
$#T = -1;
foreach my $name (sort keys %pairing) { my @line = split('_', $name); push @Q , $line[0]; push @T , $line[1]; }

shift @Q;
shift @T;

print @Q, "\n";
print @T, "\n";

print "\n";

##################################################################################################################################################



#exit;

##################################################################################################################################################

} else {

print "???\n???\n\n";

}

} # conditional for ss_dssp

}  # end of j loop

}

}

exit;
 sub upcase_in { return (split(' ', ` head -n $_[0] config.file | tail -n 1 `))[1]; }


