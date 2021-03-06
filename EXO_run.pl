#! /usr/bin/perl -w
use strict;
 use Term::ANSIColor qw(:constants);

################################
my $MIN_TMS = 5;
my $MIN_FAM = 15; # if set to 5, 7 results. -- these settings 5 and 15 give just one superfamily..
################################

system("clear");

` ./step18.pl $MIN_TMS $MIN_FAM`; # MemList

system("clear");

` rm -rf BATCH `;
` mkdir BATCH `;

my @list = ` ls -d BATCH_* 2> /dev/null  `;
if( @list < 1) { print ' No matches ... ', "\n"; exit; }
#print BLUE, scalar @list, RESET, "\n";

for(my $i=0; $i<@list; $i++) {
chomp $list[$i];

system("clear");
print BLUE, ($i+1), '/', (scalar @list), RESET, "\n";
print RED, $list[$i], RESET, "\n";
my @line = split('_', $list[$i]);
#print $line[1], "\n";
#print $line[2], "\n";

` rm -rf BACKUP `;
` mkdir BACKUP `;
` cp -r $list[$i]/* BACKUP/ `;

system(" ./GLOBAL_run.pl $line[1] $line[2] 4 5 3 2 ");

` mkdir BATCH/$list[$i] `;
` mv step8.out BATCH/$list[$i] `;
` mv step14.out BATCH/$list[$i] `;


 

` rm -f step17.out `;
#################################### REPRINTING OPS
` ./LOCAL_run.pl ynnnn `; 
` rm -f *.out `;
`  rm -rf BACKUP_CONS `;
` rm -f domtblout.txt `;
` rm -f step11b.out `;
` rm -f step9.out `;
}

exit;


