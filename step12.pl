#! /usr/bin/perl -w
use strict;
  use Term::ANSIColor qw(:constants);
use Data::Dumper;

open(FILE, "step11.out");
my @file = <FILE>;
close(FILE);

my %hash;
my %hash2;

### INITIALIZE HASH ###

for(my $i=0; $i<@file; $i++) {
my @line = split(' ', $file[$i]);
if ( scalar @line > 1 ) {  } else {
my @line2 =split('\.', $file[$i]);
$hash{$line2[1]} = 'uninitialized';
$hash2{$line2[1]} =100; 
}
}

###############################################################

my $last_model ='';
my $last_target='';

for(my $i=0; $i<@file; $i++) {
chomp $file[$i];
my @line = split(' ', $file[$i]);
my $score=100;
if ( scalar @line > 1 ) { $score = $line[6] ; } else {
my @line2 =split('\.', $file[$i]);
 $last_model =$line2[0];
 $last_target=$line2[1];
}

if( $score < $hash2{$last_target} ) {
$hash2{$last_target} = $score;
$hash {$last_target} = $last_model;
}
}

foreach my $key (keys %hash)
{
  my $value = $hash{$key};
  print $key, " "; 

 print $value, "_";

my $avg = (split(' ', ` grep '$key' step12b.out `))[2];
my $sd  = (split(' ', ` grep '$key' step12b.out `))[3];

my $struc = (split(' ', ` grep '$key' step13.out `))[1];
#print '$struc=',$struc,"\n";

#print $avg, "\t";
#print $sd, "\t";
# print $hash2{$key}, "\t";

if ( $struc ) { print '$struc=',$struc,"\n"; } else {
if ( $sd > 0 and $value ne 'uninitialized' ) {  my $z_score = abs( $hash2{$key} - $avg ) / $sd; 
printf ("%.2f", $z_score);
print "\n";
 } else {
print 'undef', "\n";
}
}

}


exit;

