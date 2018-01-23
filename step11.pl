#!/usr/bin/perl -w 
use strict;
  use Term::ANSIColor qw(:constants);

` rm -rf REPEAT/ `;
` mkdir REPEAT/ `;

my @CLUSTER = ` ls CLUSTER/ `;

my $REPEAT_LENGTH ;
my $START_POINT=0   ;
my $FAMILY        ;

my %history;

my @TOPCONS;
my @TOPCONS_M;
my @SEQUENCE;

#$FAMILY        = $CLUSTER[int(rand(scalar @CLUSTER))];
foreach $FAMILY (@CLUSTER) {
chomp $FAMILY;

` rm -rf REPEAT/ `;
` mkdir REPEAT/ `;

my @TMS = split('_', $FAMILY);
my @MODEL = split("\n", ` ./step11.bb $TMS[-1] ` );

#print RED, scalar @MODEL, RESET, "\n";

if(scalar @MODEL == 0) {
@MODEL = split("\n", ` ./step11.b $TMS[-1] ` ); # FALLBACK
}

for(my $loop=0; $loop<@MODEL; $loop++) {

my @split_MODEL = split('\+', $MODEL[$loop]);
#print ON_RED, "@split_MODEL\n", RESET;

$START_POINT = $split_MODEL[0]+1;
$REPEAT_LENGTH = $split_MODEL[1];

 @TOPCONS = split('',    ` grep -A 1 '^TOPCONS '     CONS/$FAMILY/seq_0/query.result.txt | tail -n 1 `);  pop @TOPCONS;
 @SEQUENCE= split('',    ` grep -A 1 '^Sequence:'   CONS/$FAMILY/seq_0/query.result.txt | tail -n 1 `);  pop @SEQUENCE;

 @TOPCONS_M = split ( /M+/, join('',@TOPCONS));

#print RED, '$REPEAT_LENGTH ', "\t", $REPEAT_LENGTH , "\n";
#print  '$START PT. ', "\t",$START_POINT , "\n";
#print 'OFFSET     ', "\t", $START_POINT-1 , "\n";
#print  '$FAMILY ', "\t",$FAMILY , RESET, "\n";

#print @TOPCONS, "\n";
#print @SEQUENCE, "\n";

#print GREEN, scalar @TOPCONS_M-1, RESET, "\n"; # TMS COUNTER

#print STDERR '.';

my $index=1;
my $block=0;
my $output='' ;
my $tail='';

for(my $i=0; $i<@TOPCONS; $i++) {
if($TOPCONS[$i] eq 'M' and $TOPCONS[$i-1] ne 'M') { $index++; }
if($TOPCONS[$i] eq 'M' and $index > $START_POINT and $index < $START_POINT+$REPEAT_LENGTH ) { $block=1; }
if($TOPCONS[$i] ne 'M' and $index >= $START_POINT+$REPEAT_LENGTH ) { $block=0; }
if($block==1) {  $output .= $SEQUENCE[$i]; }
#if($block==0) { print '_'; }
if($block==0 and $index > $START_POINT+$REPEAT_LENGTH+$split_MODEL[2] and $index <= $START_POINT+$REPEAT_LENGTH+$split_MODEL[2]+$REPEAT_LENGTH ) { $tail .= $SEQUENCE[$i]; }
}

#print "\n";
#print YELLOW, $output, RESET, "\n";
#print ON_YELLOW, $tail, RESET, "\n";

` echo '>temp' > temp.fa `;
` echo $output >> temp.fa `;

` echo '>temp' > tail.fa `;
` echo $tail >> tail.fa `;


######################################################################################

 ` jackhmmer --chkhmm REPEAT/$MODEL[$loop].$FAMILY.hmm --fast --F1 1e-150 --F2 1e-150 --F3 1e-150 --incdomE 1e-150 --incE 1e-150 -E 1e-150 --domE 1e-150 --noali -N 5 temp.fa uniprot_sprot.fasta `;

######################################################################################

` rm -f temp.fa `;



} # MAIN FOR LOOP

######################################################################################

` echo '>temp' > temp.fa `;
my $seq = join('',@SEQUENCE);
` echo $seq >> temp.fa `;

######################################################################################

#print STDERR "\n";

foreach my $hmm ( ` ls REPEAT/ ` ) {

chomp $hmm;
print $hmm, "\n";

` hmmalign REPEAT/$hmm temp.fa `;
` hmmpress REPEAT/$hmm `;
` hmmscan --domtblout scan.domtblout --noali REPEAT/$hmm tail.fa  `;
my @input = ` grep -v '#' scan.domtblout `;
#chomp $input;

for(my $x=0; $x<@input; $x++) {

chomp $input[$x];




print $input[$x], "\n";



}

}

if(scalar @MODEL == 1) {
#push @MODEL, $MODEL[-1];
#print GREEN, scalar @MODEL, RESET, "\n";
print 'temp                 -            178 temp                 -            201   5.1e-23   67.8   7.0   1   2   5.1e-23   5.1e-23   67.8   7.0   134   178     1    45     1    45 0.99 -', "\n";
}


}

` rm -f temp.fa `;
` rm -f tail.fa `;
` rm -f scan.domtblout `;

exit;


