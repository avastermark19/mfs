#! /usr/bin/perl -w
use strict;
  use Term::ANSIColor qw(:constants);

#PARAMETERS

#########################################################################
my @dir = ` ls CLUSTER `;

for(my $i=1; $i<@dir; $i++) {
chomp $dir[$i];

my @Q = split(' ', ` grep '^Q ' CLUSTER/$dir[$i]/HHALIGN/$dir[$i].hhalign | grep -v 'Consensus' `);

for(my $loop=6; $loop<@Q; $loop+=3) { $Q[3] .= $Q[$loop];    }

print RED $dir[$i], RESET, "\n";
open(FILE, ">temp.fa");
print FILE '>'.$dir[$i], "\n";
print FILE $Q[3], "\n";
close(FILE);

 ` time jackhmmer --chkhmm CLUSTER/$dir[$i]/$dir[$i].hmm --fast --F1 1e-150 --F2 1e-150 --F3 1e-150 --incdomE 1e-150 --incE 1e-150 -E 1e-150 --domE 1e-150 --noali -N 5 temp.fa uniprot_sprot.fasta `;

my @iterations = ` ls CLUSTER/$dir[$i]/$dir[$i].hmm-*.hmm `;
chomp $iterations[-1];
 ` mv $iterations[-1] CLUSTER/$dir[$i]/seq.hhm `;

foreach (@iterations) { chomp $_; print $_, "\n"; ` rm -f $_ `; }

 ` rm -f temp.fa `;
 ` rm -f trash.temp `;

 ` echo > STEP7_COMPLETED `;

}

exit;


