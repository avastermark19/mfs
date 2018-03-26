#! /usr/bin/perl -w
use strict;
use Data::Dumper;
 use Term::ANSIColor qw(:constants);

my $HELIX_LENGTH = 10;

my $target = ` ls -d LOOP/*/ `;
chomp $target;
print GREEN, '_'.$target.'_', RESET, "\n";

my $SEQ     = ` grep -A 1 '^Sequence:' $target/query.result.txt | tail -n 1`;

chomp $SEQ;
#print $SEQ, "\n";

my $TOPCONS = ` grep -A 1 '^TOPCONS ' $target/query.result.txt | tail -n 1`;
chomp $TOPCONS;

#$TOPCONS = 'M'.$TOPCONS.'M';

#print $TOPCONS, "\n";

$TOPCONS =~ s/M/m/g;

#print $TOPCONS, "\n";

my @TMS_ARRAY;
my $TMS_NUMBER=0;

for(my $i=0; $i<split('', $SEQ); $i++) {

if( (split('', $TOPCONS))[$i] eq 'm' 
 or   ( (split('', $TOPCONS))[$i+1] and  (split('', $TOPCONS))[$i+1] eq 'm' ) 
 or   ( (split('', $TOPCONS))[$i-1] and  (split('', $TOPCONS))[$i-1] eq 'm' )


 ) {
$TMS_ARRAY[$TMS_NUMBER] .= (split('', $SEQ))[$i];
}

if( (split('', $TOPCONS))[$i-1] eq 'm' 
and (split('', $TOPCONS))[$i  ] ne 'm' 
) {
$TMS_NUMBER++;
}

}

#print "@TMS_ARRAY\n";

for( my $j=0; $j<@TMS_ARRAY; $j++ ) {

print RED, 'TMS'.($j+1), "\t";

my @matches = (substr $TMS_ARRAY[$j], 0, 2) =~ m/(D|E)/g;
my @matches2= (substr $TMS_ARRAY[$j], 0, 2) =~ m/(K|R)/g;

my @matches3= (substr $TMS_ARRAY[$j], 20, 2) =~ m/(D|E)/g;
my @matches4= (substr $TMS_ARRAY[$j], 20, 2) =~ m/(K|R)/g;

print BLUE, "@matches\t";
print GREEN, "@matches2\t";

print ( RED, (substr $TMS_ARRAY[$j], 0, 1) , RESET, "");
print ( (substr $TMS_ARRAY[$j], 1, -2) , RESET, "");
print ( RED, (substr $TMS_ARRAY[$j], -2, 1) , RESET, "\t");

print BLUE,  "@matches3\t";
print GREEN, "@matches4\n";

}

exit;

