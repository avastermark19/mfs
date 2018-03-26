#! /usr/bin/perl -w 
use strict;

 use Term::ANSIColor qw(:constants);

my $LOOP_LENGTH=30;
#####################################################################
# http://ecoli.med.utoronto.ca/membrane/php/home.php
# https://www.uniprot.org/docs/ecoli.txt
# http://ecoli.med.utoronto.ca/membrane/php/data/Babu_et_al_2017_Ecoli_CEP_PPI_APMS_data.zip
# aake@ae17a:~/clone30/mfs$ blastall -p blastp -i SV2A.substr -d uniprot_sprot.fasta -m 8 -e 1000 | grep 'ECOLI'
# aake@ae17a:~/clone30/mfs$ makeblastdb -in uniprot_sprot.fasta -dbtype 'prot'

#aake@ae17a:~/clone30/mfs$ blastall -p blastp -i SV2A.substr -d uniprot_sprot.fasta -m 8 -e 1000 | grep 'ECOLI'
#1	sp|P0AE24|ARAE_ECOLI	45.161	31	17	0	2	32	199	229	0.056	34.7
#1	sp|P76230|YDJK_ECOLI	35.294	34	22	0	2	35	203	236	0.46	32.0
#1	sp|P0AGF4|XYLE_ECOLI	28.571	42	30	0	2	43	221	262	2.3	30.0
#1	sp|P75916|YCDZ_ECOLI	40.000	35	21	0	51	85	2	36	16	27.3
#1	sp|P0AEP1|GALP_ECOLI	29.545	44	31	0	2	45	192	235	42	26.6
#1	sp|P21889|SYD_ECOLI	28.814	59	37	2	2	55	191	249	129	25.0

#aake@ae17a:~/clone30/mfs$ blastall -p blastp -i SV2A.substr -d uniprot_sprot.fasta -m 8 -e 1000 | grep 'ECOLI'
#1	sp|P32704|YJCF_ECOLI	18.421	76	62	0	36	111	174	249	136	26.2
#1	sp|P77148|YDHS_ECOLI	29.730	37	24	1	44	78	103	139	159	25.8
#1	sp|P75948|THIK_ECOLI	36.111	36	22	1	1	35	202	237	301	25.0
#1	sp|P15723|DGTP_ECOLI	30.909	55	32	2	7	61	45	93	432	24.6
#1	sp|P45804|YHGE_ECOLI	60.000	15	6	0	85	99	172	186	517	24.3

#aake@ae17a:~/clone30/mfs$ grep 'YDJK' ecoli.txt 
#b1775; JW5290                      YDJK_ECOLI   P76230     EG13487                459  ydjK
#aake@ae17a:~/clone30/mfs$ grep 'b1775' interactions.txt 
#ydjH__b1772	ydjK__b1775
#entF__b0586	ydjK__b1775
#abgB__b1337	ydjK__b1775
#ribE__b0415	ydjK__b1775

# issues in old version
# last folder not uc name
# rename MAKE_report
# GLOBAL_run not prepared for releast

# command line modeller for salt bridges/
# DE/KR in the topcons
# make guide which are close
# check conservation in some homologs
#####################################################################


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
` rm -f seq.txt `;

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

my @matches = $TOPCONS =~ /(Mo{$LOOP_LENGTH,}M|Mi{$LOOP_LENGTH,}M)/g;


#print RED, "@matches\n", RESET;

open(FILE, ">LOOP/$input[1].substr");

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

` rm -f seq.txt `;

system (" ./step19.pl ");

system (" ./step20.pl ");

exit;


