#! /usr/bin/perl -w 
use strict;

 use Term::ANSIColor qw(:constants);

my @input;

my $ps = `ps | wc -l `;
if($ps != 6) { print '$ps='.$ps. ' ; kill %', "\n"; exit; }


if( $ARGV[0] ) { $input[1] = $ARGV[0] } else {
system("clear;");
print STDERR "Which SEQUENCE unit do you want to try (e.g.  default=SV2A): ";
 $input[1] = <STDIN>;
chomp $input[1];

}

$input[1] =uc ($input[1]);
if($input[1] eq '') { $input[1] = 'SV2A';}

#print RED, $input[1] , RESET, "\n";

my @GN2;
if(  (` grep 'GN=$input[1]' uniprot_sprot.fasta `)[0]  ) {
 @GN2 = split ( /\s|GN=/ ,  (` grep  'GN=$input[1]' uniprot_sprot.fasta `)[0] );
#print GREEN, "@GN2", RESET, "\n";
} else { 
print RED, 'No GN=', RESET ; 
print RED, $input[1] , RESET, "\n";
}

#####################################################################

my @seq = ` sed -n -e '/$GN2[0]/,/>/ p' uniprot_sprot.fasta  `; 
shift @seq; pop @seq;

chomp $seq[0];
for(my $i=1; $i<@seq; $i++) { chomp $seq[$i]; $seq[0] .=$seq[$i]; }

############### TOPCONS
open( FILE,">seq.txt");
print FILE ">seq\n$seq[0]\n";
close(FILE);

my %hash;

if( -e 'LOOP' and -d 'LOOP') {
if( -e "LOOP/$input[1]" ) {
print 'EXIST', "\n";
goto die1;
}
}

` rm -rf LOOP `;
` mkdir LOOP `;

my @python = split ( ' ', ` python topcons2_wsdl.py -m submit -seq seq.txt ` );


print GREEN, (split(/\|/, $GN2[0]))[2], ' ';
print BLUE $python[11], RESET "\n";
 $hash{$input[1]} = $python[11];

do {
while( my( $key, $value ) = each %hash ){ # key is name, value is jobid
print STDERR '.';
#print $key, ' ', $value, "\n";
 @python = split (' ',  ` python topcons2_wsdl.py -m get -jobid $value `);
if ($python[6] ne 'not') { ` unzip $value.zip > /dev/null 2>&1 `; ` rm -f $value.zip `; `mv $value $input[1]`; ` mv $input[1] LOOP/ `;   delete $hash{$key}; }
} 
} while ( keys %hash > 0 );
` rm -f seq.txt `;
print STDERR "\n";

#####################################################################

die1:

my $SEQ     = ` grep -A 1 '^Sequence:' LOOP/$input[1]/query.result.txt | tail -n 1`;

chomp $SEQ;
#print $SEQ, "\n";

my $TOPCONS = ` grep -A 1 '^TOPCONS ' LOOP/$input[1]/query.result.txt | tail -n 1`;
chomp $TOPCONS;

$TOPCONS = 'M'.$TOPCONS.'M';

#print $TOPCONS, "\n";

my @matches = $TOPCONS =~ /(Mo{30,}M|Mi{30,}M)/g;


#print RED, "@matches\n", RESET;

open(FILE, ">LOOP/substr.txt");

for(my $i=0; $i<@matches; $i++) {
#print index($TOPCONS, $matches[$i]) , "\t", index($TOPCONS, $matches[$i]) + length($matches[$i]), "\n" ;
my $start = index($TOPCONS, $matches[$i]);
my $end   = index($TOPCONS, $matches[$i]) + length($matches[$i]);

#print $start+1-1, ' ', $end-1-1, "\n";
my $substr2 = substr $SEQ, ($start+1-1),  length($matches[$i])-1-1;

print FILE $substr2, "\n";

}


close(FILE);

#RESTORE STRING
$TOPCONS =~ s/^.//; # chop the first character
chop $TOPCONS;
print GREEN, $TOPCONS, RESET, "\n";



exit;


