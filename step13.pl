#!/usr/bin/perl -w
use strict;
use Term::ANSIColor qw(:constants);

# ` ./step5.pl > step5.out `;
` ./step5.pl `;

` rm -rf PDB/ `;
` mkdir PDB/ `;

my %best;

my @input = ` cat step5.out `;
for(my $i=0; $i<@input; $i+=2) {

chomp $input[$i];
chomp $input[$i+1];

` rm -f temp.fa `;
` echo '$input[$i]' > temp.fa `;
` echo $input[$i+1] >> temp.fa `;

my $query_length = length($input[$i+1]);

#####################################################################################

# Need to check if this sequence has info in CONS/

my $name = join ('', ( split('', $input[$i] ))[1 .. length($input[$i])-1] );

my @cons = split("\n",` cat CONS/$name/seq_0/Homology/query.fa.total_aligns `);

if ($cons[0]) {

#####################################################################################
#print $name, "\n";

my $TMS = (split('_', $input[$i]))[-1];
my @models = ` ./step16.pl $TMS bb `;

my @name = split( /\||\/|\s/,  $cons[0]);

my $start = (split('-', $name[2]))[0];
my $end = (split('-', $name[2]))[1];

chomp $cons[1];
chomp $cons[3];

my $cc = uc (join( '', (split('', $name[1]))[0 .. 3]).'_'.(split('', $name[1]))[4] );

my $sought_chain = (split('', $name[1]))[4];

chop $name[1];

my $best_score=999;

` wget -nc -q "https://files.rcsb.org/view/$name[1].pdb" `;
` mv $name[1].pdb PDB/ `;
` grep '^ATOM' PDB/$name[1].pdb | grep ' CA '  > PDB/$name[1].CA `;

#####################################################################################

my @alpha = ('a','b','c','d','e','f','g','h','i', 'j','k','l', 'm','n','o');

# too lonely
$cons[1] =~ s/(o|i|-)M(o|i|-)/---/g;
$cons[1] =~ s/(o|i|-)MM(o|i|-)/----/g;

# too close
$cons[1] =~ s/MMM(o|i|-)(o|i|-)MMM/MMMMMMMM/g;
$cons[1] =~ s/MMM(o|i|-)(o|i|-)(o|i|-)MMM/MMMMMMMMM/g;
$cons[1] =~ s/MMM(o|i|-)MMM/MMMMMMM/g;

foreach my $mod (@models) {
chomp $mod;
my @split_mod = split('\+', $mod);
#print $name, "\t";
#print ON_RED, uc($name[1]), $sought_chain, RESET, "\t";
#print ON_BLUE, $mod, RESET, "\t";

my @split_cons1 = split('', $cons[1]);
my $which_TMS=-1;
my $run_TMS=0;

my @TMS_MAP;
$#TMS_MAP=-1;

for(my $i=0; $i<@split_cons1; $i++) {

if ( $split_cons1[$i-1] ne 'M' and $split_cons1[$i-2] ne 'M' and $split_cons1[$i-3] ne 'M' and $split_cons1[$i-4] ne 'M' and
     $split_cons1[$i] eq   'M'
 ) { $which_TMS++; $run_TMS=0; $TMS_MAP[$which_TMS]=$i+$start; }

if($run_TMS > 30) { $which_TMS++; $run_TMS=0; $TMS_MAP[$which_TMS]=$i+$start;  }

if ( $split_cons1[$i] eq 'M' ) { $run_TMS++; } else { ;}

}


if(scalar @TMS_MAP == $TMS) { #print 'TESTABLE', "\t"; 

################### OBTAIN ###################

open(FILE_A, ">segment_A");
open(FILE_B, ">segment_B");

open(FILE_C, ">segment_A.simple");
open(FILE_D, ">segment_B.simple");




foreach my $line (` cat PDB/$name[1].CA `) {
chomp $line;
my $res_ID = join('',(split('', $line))[22 .. 25]);
my $x = join('',(split('', $line))[30..37]);
my $y = join('', (split('', $line))[38..45]);
my $z = join('',(split('', $line))[46..53]);
my $chain = (split('', $line))[21];



#print $line, "\n";

if ($chain eq $sought_chain and $res_ID >= $TMS_MAP[$split_mod[0] ] and $res_ID <= $TMS_MAP[$split_mod[1] + $split_mod[0] -1 ]+20)  { print FILE_A $line, "\n"; print FILE_C $x, ' ', $y, ' ', $z, "\n"; }
if ($chain eq $sought_chain and $res_ID >= $TMS_MAP[$split_mod[0] + $split_mod[1] + $split_mod[2]  ] and $res_ID <= $TMS_MAP[$split_mod[0] + $split_mod[1] + $split_mod[2] + $split_mod[3] -1 ]+20) { print FILE_B $line, "\n"; print FILE_D $x, ' ', $y, ' ', $z, "\n";}

};

close(FILE_A);
close(FILE_B);

close(FILE_C);
close(FILE_D);

my @len = split(' ', ` wc -l *simple `);

if( $len[0] > $len[2] ) { ` head -n $len[2] segment_A.simple > temp; mv temp segment_A.simple ` }
if( $len[0] < $len[2] ) { ` head -n $len[0] segment_B.simple > temp; mv temp segment_B.simple ` }

if( $len[0]/$len[2] > 1.2 or $len[2]/$len[0] > 1.2 ) {   } else { #print '*too different*', "\n"; } else {
#print 'SIMILAR ENOUGH', "\t";
#print (`./rmsd.exe segment_A.simple segment_B.simple`);

##############################################



##############################################




my $TM_align1=( split(' ', ` ./TMalign segment_A segment_B | head -n 19 | tail -n 1`))[1];
my $TM_align2=( split(' ',` ./TMalign segment_A segment_B | head -n 18 | tail -n 1`))[1];
my $TM_align_avg = ($TM_align1+$TM_align2)/2;

my $score= (split(' ',` ./AE_RMSD.exe segment_A segment_B `))[5] ;
print $name, "\t";
print $mod, "\t";
print $score, "\t";
print $TM_align_avg, "\n";


##############################################
print $name, "\n";
#print ON_RED, "@TMS_MAP\n", RESET;

unless ( -e "STEP7_COMPLETED" ) {

my $border0 = $TMS_MAP[$split_mod[0]  ];
my $border1 = $TMS_MAP[$split_mod[0] + $split_mod[1]  ];
my $border2=  $TMS_MAP[$split_mod[0] + $split_mod[1] + $split_mod[2] ];
my $border3 = $TMS_MAP[$split_mod[0] + $split_mod[1] + $split_mod[2] + $split_mod[3] ];

#print ON_RED, $border, RESET, "\n";
#print ON_RED, $query_length, RESET;

my $hh_result = ` hhalign -i CLUSTER/$name/seq.hhm -t CLUSTER/$name/seq.hhm -nocontxt -cov 100 -loc -E 10 -excl 0-$border2 -template_excl $border1-$query_length `;


print $hh_result, "\n";

}

##############################################



if( $score < $best_score ) { $best{$name} = $mod; $best_score=$score; }
#exit;

}

################### OBTAIN ###################

} else {  } # print '*not* TESTABLE', "\n"; }

}

} # is there something to work with

}

` rm -f temp.fa `;

#print $best{Sugar_tr_12};

open(FILE, ">step13.out");
print FILE "$_ $best{$_}\n" for (sort keys %best);
print FILE 'default 0+0+0+0+0', "\n";
close(FILE);

exit;

