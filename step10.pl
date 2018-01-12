#! /usr/bin/perl -w
use strict;
  use Term::ANSIColor qw(:constants);

open(FILE, "step6.out");
my @file = <FILE>;
close(FILE);

for (my $i=0; $i<(@file/4); $i++ ) {

my $label = $file[4*$i];
my @upper = split('', $file[4*$i+1]);
my @lower = split('', $file[4*$i+2]);

chomp $label;
chomp $upper[-1];
chomp $lower[-1];

####################################################################################################
#(sort @names)[0, -1];
# my $middle = substr $s, 4, -11;    # black cat climbed the
####################################################################################################

my @beginning;
my @upper2;
my @lower2;

for( my $j=0; $j<@upper; $j++) {

if($upper[$j] eq '-') {

push @beginning, $lower[$j];

}  else {

push @upper2, $upper[$j];
push @lower2, $lower[$j];

}

}

####################################################################################################

for(my $j=0; $j<@beginning; $j++) {

my $k;

for( $k=0; $k<@lower2; $k++) { 

####################################################################################################

#if( $beginning[$j] ne '-' and $lower2[$k] ne '-'  and  ord($beginning[$j]) < ord($lower2[$k]) ) { last; }
if(   ord($beginning[$j]) < ord($lower2[$k]) ) { last; }

####################################################################################################

}

splice @upper2, $k, 0, '-';
splice @lower2, $k, 0, $beginning[$j];

}

print    $label,  "\n";
print  @upper2,  "\n";
print   @lower2,  "\n";
print "\n";

####################################################################################################

}

exit;

