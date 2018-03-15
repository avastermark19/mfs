#! /usr/bin/perl -w
use strict;
  use Term::ANSIColor qw(:constants);

# formerly MemList

system("clear;");

#################################################
my $MIN_TMS    = 5;
my $MIN_FAMILY = 5;
#################################################

` ./ClanTester.pl $MIN_FAMILY > ClanTester.out `;

my @list = ` cat ClanTester.out `;
print STDERR RED, scalar @list, RESET, "\n";

my %hash;

my %select;
#16712 
#56
#do{
#$select{int(rand(16712-10))} = 1;
#} while ( keys %select < 10 );

# 56 from sample.txt
for(my $i=0; $i<scalar @list; $i++) { $select{$i} = 1; }

while( my( $key, $value ) = each %select ){
#print $key, ' ', $value, "\n";
}
#exit;

#for(my $i=0; $i<@list; $i++) {
#for(my $i=0; $i<10; $i++) {
while( my( $i, $value ) = each %select ){

my @line = split(' ', $list[$i]);
chomp $line[-1];
print STDERR $line[0], "\t";

` wget -nc -q "https://pfam.xfam.org/family/$line[0]/alignment/seed/format?format=fasta&alnType=seed&order=t&case=l&gaps=none&download=1" `;

# format\?format\=fasta\&alnType\=seed\&order\=t\&case\=l\&gaps\=none\&download\=1

my $name = ( split( /\>|\//, ` head -n 1 format\\?format\\=fasta\\&alnType\\=seed\\&order\\=t\\&case\\=l\\&gaps\\=none\\&download\\=1 ` ))[1];
                                       #format\?format\=fasta\&alnType\=seed\&order\=t\&case\=l\&gaps\=none\&download\=1

print STDERR BLUE, $name, RESET, "\t";

` sed -n -e '/$name/,/>/ p' format\\?format\\=fasta\\&alnType\\=seed\\&order\\=t\\&case\\=l\\&gaps\\=none\\&download\\=1 > sample.txt `; 

` sed -i '\$ d' sample.txt `; # last line gone

my @python = split ( ' ', ` python topcons2_wsdl.py -m submit -seq sample.txt ` );
print STDERR BLUE $python[11], RESET "\n";
 $hash{$line[0]} = $python[11];
` rm -f sample.txt `;
#exit;

` rm -f format\\?format\\=fasta\\&alnType\\=seed\\&order\\=t\\&case\\=l\\&gaps\\=none\\&download\\=1  `;

} 

#######################################################

` rm -rf MemList; `;
` mkdir MemList; `;

do {
print STDERR scalar(keys %hash), ' ';
while( my( $key, $value ) = each %hash ){ # key is name, value is jobid
my @python = split (' ',  ` python topcons2_wsdl.py -m get -jobid $value `);
if ($python[6] ne 'not') { ` unzip $value.zip `; ` rm -f $value.zip `; ` mv $value MemList/$key `; delete $hash{$key}; }
}
} while ( keys %hash > 0 );

#######################################################

print STDERR "\n";

my @MemList = ` ls MemList `;
#print scalar @MemList, "\n";

for(my $j=0; $j < @MemList; $j++) {

chomp $MemList[$j];

my @TOPCONS = split('M+', ` grep -A 1 '^TOPCONS' MemList/$MemList[$j]/query.result.txt | tail -n 1 `);
shift(@TOPCONS);

my %known;
$known{'CL0062'}=1;
$known{'CL0184'}=1;
$known{'CL0064'}=1;
$known{'CL0015'}=1;
$known{'CL0322'}=1;
$known{'CL0292'}=1;
$known{'CL0430'}=1;
$known{'CL0182'}=1;
$known{'CL0181'}=1;
$known{'CL0241'}=1;

my $clan_id = (split(' ', ` grep '$MemList[$j]' Pfam-A.clans.tsv `))[1];

if ( scalar @TOPCONS > $MIN_TMS ) { 

print GREEN, $clan_id, "\t", RESET;

if( exists $known{$clan_id} ) {} else {

my $clan = (split(' ', ` grep '$MemList[$j]' Pfam-A.clans.tsv `))[2];
print GREEN, $clan, "\t", RESET;

my $SPACE = scalar @TOPCONS;
my $half_SPACE ;
if (0 == $SPACE % 2) { $half_SPACE = $SPACE/2; } else { $half_SPACE = ($SPACE-1)/2; }

print YELLOW, $MemList[$j], ' ', $SPACE, ' ', $half_SPACE, RESET; # STDOUT

print "\n";
` ./step1.pl $clan_id `;
` ./step2.pl `;

my $outdir = 'BATCH_'.$clan_id.'_'.$half_SPACE;
` rm -f $outdir `;
` mkdir $outdir `;
` cp -r TOPCONS/* $outdir/ `;

}

print "\n";

}
else { print GREEN, $clan_id, "\n", RESET; }

}

` rm -rf MemList; `;

exit;


