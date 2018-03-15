#! /usr/bin/perl -w
use strict;
  use Term::ANSIColor qw(:constants);

` rm -rf TOPCONS/ `;
` mkdir TOPCONS/ `;

# REQUIRED FILE topcons2_wsdl.py
my $counter;
my @output = `cat domtblout.txt `;
for(my $i=0; $i<3; $i++) { shift @output; }
for(my $i=0; $i<10; $i++) { pop @output; }

my %hash;
for(my $i = 0; $i < @output; $i++) { my @line = split(/\s|\|/, $output[$i]); if (-e "TOPCONS/$line[1]" and -d "TOPCONS/$line[1]" ) {} else { $hash{$line[1]}=1 ; } }

while( my( $key ) = each %hash ){ 
$counter++;

my @seq = ` sed -n -e '/$key/,/>/ p' uniprot_sprot.fasta  `; 
shift @seq; pop @seq;

chomp $seq[0];
for(my $i=1; $i<@seq; $i++) { chomp $seq[$i]; $seq[0] .=$seq[$i]; }

############### TOPCONS
open( FILE,">seq.txt");
print FILE ">seq\n$seq[0]\n";
close(FILE);

my @python = split ( ' ', ` python topcons2_wsdl.py -m submit -seq seq.txt ` );
#print BLUE $counter, "\t", $python[11], "\t", $key, RESET "\n";
print STDERR '.';
 $hash{$key} = $python[11];
} # DOES DIR EXIST?

do {
if($counter) {print "\b\b\b\b\b\b\b\b-> =", int(100*((keys %hash)/$counter)), '% ';}
while( my( $key, $value ) = each %hash ){ # key is name, value is jobid
my @python = split (' ',  ` python topcons2_wsdl.py -m get -jobid $value `);
if ($python[6] ne 'not') { ` unzip $value.zip > /dev/null 2>&1 `; ` rm -f $value.zip `; ` mv $value TOPCONS/$key `; delete $hash{$key}; }
} 
} while ( keys %hash > 0 );
if($counter){print "\n";}
` rm -f seq.txt `;
exit;
  sub upcase_in { return (split(' ', ` head -n $_[0] config.file | tail -n 1 `))[1]; }

