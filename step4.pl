#! /usr/bin/perl -w
use strict;
 use Term::ANSIColor qw(:constants);

## PARAMETER ##
###############

my $val='library(ape); B=matrix(c(';
my $colnames='colnames(B) <- c("';

my @dim = ` ls CLUSTER/ `;

my $A=0;

foreach my $DIR (@dim) { 
chomp $DIR;

$colnames .= $DIR.'","';

#` rm -rf CLUSTER/$DIR/HHALIGN/ `;
#` mkdir CLUSTER/$DIR/HHALIGN/ `;

foreach my $DIR2 (` ls CLUSTER/ `) { 
chomp $DIR2;

print STDERR $DIR, RESET, "\t";
print STDERR $DIR2, RESET, "\t";

$A++;
#if($A>2) { exit; }
 
#` hhalign -i CLUSTER/$DIR/seq.hhm -t CLUSTER/$DIR2/seq.hhm -nocontxt -glob -cov 100 -o CLUSTER/$DIR/HHALIGN/$DIR2.hhalign 2> trash `;

` hhalign -v 0 -i CLUSTER/$DIR/seq.hhm -t CLUSTER/$DIR2/seq.hhm -nocontxt -glob -cov 100 -o CLUSTER/$DIR/HHALIGN/$DIR2.hhalign >> /dev/null 2>&1  `;

#> /dev/null 2>&1

my @score = split(' ', ` grep -A 3 "^Command" CLUSTER/$DIR/HHALIGN/$DIR2.hhalign | tail -n 1 `);
print STDERR $score[5], RESET, "\t";
if( $score[5] >= 1 ) { $score[5] = 10-log($score[5]); }  else { $score[5] = 10; } 
print STDERR $score[5], RESET, "\n";

$val .= $score[5].',';

}

}

chop $val;
chop $colnames; 
chop $colnames;
$colnames .= ');';

$val .= '),nrow='.(scalar @dim).',ncol='.(scalar @dim).');'.$colnames.' tre = nj(as.dist(B)); write.nexus(tre, file = "TREE_COI.nex");';

` echo '$val' > temp.R `;
` Rscript temp.R `;
print ` cat TREE_COI.nex `;
` rm -f trash `;
` rm -f temp.R `;

exit;

