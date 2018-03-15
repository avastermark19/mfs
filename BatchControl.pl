#! /usr/bin/perl -w
use strict;
 use Term::ANSIColor qw(:constants);

system("clear");

` rm -rf BatchControl `;
` mkdir BatchControl `;

my @list = ` ls -d BATCH_* `;
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

` mkdir BatchControl/$list[$i] `;
` mv step8.out BatchControl/$list[$i] `;
` mv step14.out BatchControl/$list[$i] `;


 
}


exit;


