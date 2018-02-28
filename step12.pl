#! /usr/bin/perl -w
use strict;
  use Term::ANSIColor qw(:constants);
use Data::Dumper;

if( $ARGV[0] and ($ARGV[0] eq 'a' or $ARGV[0] eq 'b') ) {

if( $ARGV[0] eq 'a' ) { open(FILE, "step11.out"); }
if( $ARGV[0] eq 'b' ) { open(FILE, "step11b.out"); }
my @file = <FILE>;
close(FILE);

my %hash;
my %hash2;
my %hash3;
my %hash4;
my %hash5;

### INITIALIZE HASH ###

for(my $i=0; $i<@file; $i++) {
my @line = split(' ', $file[$i]);
if ( scalar @line > 1 ) {  } else {
my @line2 =split('\.', $file[$i]);
$hash{$line2[1]} = 'uninitialized';
$hash2{$line2[1]} =100; 
$hash3{$line2[1]} =0;
$hash4{$line2[1]} =0;
$hash5{$line2[1]} =0;
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

if( $ARGV[0] eq 'b' ) {  # B MODE...
unless ($score == 100) { 
$hash3{$last_target} += $score; 
$hash4{$last_target}++;
}
} # B MODE ...

if( $score < $hash2{$last_target} ) {
$hash2{$last_target} = $score;
$hash {$last_target} = $last_model;
}
}

###############################################################

if( $ARGV[0] eq 'a' ) {  # A MODE...
foreach my $key (keys %hash)
{
  my $value = $hash{$key};
  print $key, " "; 
 print $value, "_";
my $avg = (split(' ', ` grep '$key' step12b.out `))[2];
my $sd  = (split(' ', ` grep '$key' step12b.out `))[3];
my $struc = (split(' ', ` grep '$key' step13.out `))[1];
if ( $struc ) { print '$struc=',$struc,"\n"; } else {
if ( $sd and $sd > 0 and $value ne 'uninitialized' ) {  my $z_score = abs( $hash2{$key} - $avg ) / $sd; 
printf ("%.2f", $z_score);
print "\n";
 } else {
print 'undef', "\n";
}
}
}
} # A MODE ...

if( $ARGV[0] eq 'b' ) {  # B MODE...
 $last_model ='';
 $last_target='';
for(my $i=0; $i<@file; $i++) {
chomp $file[$i];
my @line = split(' ', $file[$i]);
my $score=100;
if ( scalar @line > 1 ) { $score = $line[6] ; } else {
my @line2 =split('\.', $file[$i]);
 $last_model =$line2[0];
 $last_target=$line2[1];
}
unless ($score == 100) { 
$hash5{$last_target} += ($score-($hash3{$last_target}/$hash4{$last_target}))**2;
}
}
foreach my $key (keys %hash)
{
  my $value = $hash{$key};
if (     ($hash4{$key} - 1) != 0 ) {
print $key, " ";
 print $value, " ";
 print $hash3{$key}/$hash4{$key}, "\t";
print sqrt( $hash5{$key} / ($hash4{$key} - 1) ), "\n";
}
}
} # B MODE ...

} else { print '  ARGV issue ', "\n"; }

exit;

