#! /usr/bin/perl -w 
use strict;
use Data::Dumper;
 use Term::ANSIColor qw(:constants);

` rm -f EC_MP_PPI_unfiltered_raw_Apr11-2017.txt `;
` rm -f ecoli.txt `;

print RED, "Downloading .";
` wget -nc -q "https://www.uniprot.org/docs/ecoli.txt" `;
print RED, '.';
` wget -nc -q "http://ecoli.med.utoronto.ca/membrane/php/data/Babu_et_al_2017_Ecoli_CEP_PPI_APMS_data.zip" `;
print RED, '.';
print RESET, "\n";

` unzip Babu_et_al_2017_Ecoli_CEP_PPI_APMS_data.zip `;
` rm -f README `;
` rm -f Babu_et_al_2017_Ecoli_CEP_PPI_APMS_data.zip `;
` rm -f EC_MP_WT_PPI_unfiltered_raw_Apr11-2017.txt `;

` rm -f *.phr `;
` rm -f *.pin `;
` rm -f *.psq `;

if( -e "uniprot_sprot.fasta" ) {
print RED, "Building DB ...";
` makeblastdb -in uniprot_sprot.fasta -dbtype 'prot' `;
} else { print 'uniprot_sprot.fasta missing...', "\n"; exit; }
print RESET, "\n";

my $target = ` ls LOOP/*.substr `;
chomp $target;
print GREEN, '_'.$target.'_', RESET, "\n";

my $wc = ` cat $target | wc -l `;
chomp $wc;
#print $wc, "\n";
for(my $j=1; $j<$wc+1; $j++) {
` head -n $j $target | tail -n 1 > temp.seq `;

my @hits = ` blastall -p blastp -i temp.seq -d uniprot_sprot.fasta -m 8 -e 1000 | grep 'ECOLI' `;
#print BLUE, "@hits\n", RESET;

print "@@@@@@@@@@@@@@@@@@@@@@\n LOOP $j \n@@@@@@@@@@@@@@@@@@@@@@\n";

for(my $i=0; $i<@hits; $i++) {
my $id  = (split(/\s|\|/, $hits[$i]))[3];
#print 'ECOLI HOMOLOGUE OF LOOP: ', $id, "\t";

my $b_number = (split( /\s|;/, ` grep '$id' ecoli.txt ` ))[0];
print RED, $id, ' -> ', RESET;

my @interactants = ` grep '$b_number' EC_MP_PPI_unfiltered_raw_Apr11-2017.txt | head -n 1 `;

my %hash;
%hash=();
undef %hash;

for(my $k=0; $k<@interactants; $k++) {
my $interactant_1 =  (split( /\s|_/, $interactants[$k] ))[4] ;
my $interactant_2 =  (split( /\s|_/, $interactants[$k] ))[7] ;

if ( $interactant_1 ne $b_number ) { $hash{$interactant_1}++; 

my $c_number = (split( /\s+|;/, ` grep '$interactant_1' ecoli.txt ` ))[3];
print YELLOW, $c_number, ' -> ', RESET;

` sed -n -e '/$c_number/,/>/ p' uniprot_sprot.fasta > sample1.txt `;
` sed -i '\$ d' sample1.txt `; # last line gone
#` cat sample1.txt `;
my @hits1 = ` blastall -p blastp -i sample1.txt -d uniprot_sprot.fasta -m 8 -e 1000 | grep 'HUMAN' `;
#print BLUE, "@hits1\n", RESET;
my $HUMAN= (split(/\s|\|/, $hits1[0]))[5];
print GREEN, $HUMAN, RESET, "\n";

}
if ( $interactant_2 ne $b_number ) { $hash{$interactant_2}++; 

my $c_number = (split( /\s+|;/, ` grep '$interactant_2' ecoli.txt ` ))[3];
print RED, $c_number, ' -> ', RESET;

` sed -n -e '/$c_number/,/>/ p' uniprot_sprot.fasta > sample1.txt `;
` sed -i '\$ d' sample1.txt `; # last line gone
#` cat sample1.txt `;
my @hits1 = ` blastall -p blastp -i sample1.txt -d uniprot_sprot.fasta -m 8 -e 1000 | grep 'HUMAN' `;
#print BLUE, "@hits1\n", RESET;
my $HUMAN= (split(/\s|\|/, $hits1[0]))[5];
print GREEN, $HUMAN, RESET, "\n";

}

#print GREEN, '_'.$interactant_1.'_', RESET, "-";
#print GREEN, '_'.$interactant_2.'_', RESET, "\n";

}
#print 'INTERACTANT OTHER NAME: ';
#print Dumper(%hash), "\n";

}

}

#` rm -f ecoli.txt `;
` rm -f EC_MP_PPI_unfiltered_raw_Apr11-2017.txt `;
` rm -f temp.seq `;
` rm -f *.phr `;
` rm -f *.pin `;
` rm -f *.psq `;

# http://ecoli.med.utoronto.ca/membrane/php/home.php
# https://www.uniprot.org/docs/ecoli.txt
# http://ecoli.med.utoronto.ca/membrane/php/data/Babu_et_al_2017_Ecoli_CEP_PPI_APMS_data.zip
# aake@ae17a:~/clone30/mfs$ blastall -p blastp -i SV2A.substr -d uniprot_sprot.fasta -m 8 -e 1000 | grep 'ECOLI'
# aake@ae17a:~/clone30/mfs$ makeblastdb -in uniprot_sprot.fasta -dbtype 'prot'


exit;

