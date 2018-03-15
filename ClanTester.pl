#! /usr/bin/perl -w
use strict;
use Term::ANSIColor qw(:constants);

if( $ARGV[0] ) {

#system("clear");

open(FILE, "Pfam-A.clans.tsv");
my @file = <FILE>;
close(FILE);

my %hash;

for(my $i = 0; $i < @file; $i++) {

if(      $file[$i] =~ m/\sCL\d\d\d\d\s/ ) {

chomp $file[$i];

#print  $file[$i] , "\n";

my @line = split( ' ', $file[$i] );

#print $line[1], "\n";

$hash{$line[1]}++;

}

}

while (my ($key, $value) = each(%hash)) {
    # Something

if( $value > $ARGV[0] ) {
#print RED, $key,  ' ', $value, RESET, "\n";

################################################################

# get sample

my $sample = ` grep '$key' Pfam-A.clans.tsv | head -n 1 `;

chomp $sample;

print $sample, "\n";

################################################################

}

}

# 604 clans ?

} else { print 'ARGV', "\n"; }

exit;

