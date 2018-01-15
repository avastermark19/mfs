#! /usr/bin/perl 
use strict;
  use Term::ANSIColor qw(:constants);
#PARAMETERS
#########################################################################
open(FILE, "TREE_COI.nex");
my @file = <FILE>;
close(FILE);
@_= split( ' ', $file[4]);
chop $_[-1];
my @Names = ("void");
for(my $loop=6; $loop<$_[-1]+6; $loop++) { chomp $file[$loop]; $file[$loop] =~ s/\s//g; push @Names, $file[$loop]; }
#for(my $i=0; $i<@file-2; $i++) { chomp $file[$i]; 
for(my $i=0; $i<@file-3; $i++) { chomp $file[$i];

#########################################################################
my @split_file = split('', $file[$i]);

if( $split_file[0] and $split_file[1] and $split_file[0] eq "\t" and $split_file[1] eq "\t" )  {} else {  print $file[$i], "\n"; }

#########################################################################
}
#print $file[$i], "\n"; }
chomp $file[-2];
my @line = split( /\(|\)/, $file[-2]); 

my %tracker;

for(my $loop=0; $loop<@line; $loop++) {

 @_ = split('', $line[$loop]);
#print ' ARRAY: ', scalar @_, "\n";

if( $_[2]  ) {

$_ = $_[0];
if ( $_ and /\d/ ) {
 @_ = split( /,|:/, $line[$loop] );

#print '$line[$loop]: ', $line[$loop], "\n";
#print '$_[0]: ', $_[0], "\n";
#print '$_[2]: ', $_[2], "\n";

my $label = ` ./step10.pl | grep -A 2 '$Names[$_[0]] $Names[$_[2]]'  | tail -n 2 `;
$label =~ s/\n/\|/g;

#########################################################################

my @split_label = split('\|', $label);

#print 'xxx', "\n";
#print '_'.$Names[$_[0]] ,"_\n";
#print '_'.$Names[$_[2]] ,"_\n";
#print 'xxx', "\n";

unless ($Names[$_[0]] eq 'void') {
print "\t\t", $_[0], "\t", $Names[$_[0]];
for(my $p=0; $p<30-(length $Names[$_[0]]); $p++) { print '_'; }
if( $split_label[0] eq '???' or $split_label[0] eq '') { 


my @temp = split(' ', ` ./step12.pl | grep '$Names[$_[0]]'; `); $split_label[0] =  $temp[-1]; 

#print RED, $Names[$_[0]], RESET, "\n";
#print BLUE, $temp[-1], RESET, "\n";


} print  $split_label[0], ",\n";


}

unless ($Names[$_[2]] eq 'void') {
print "\t\t", $_[2], "\t", $Names[$_[2]];
for(my $p=0; $p<30-(length $Names[$_[2]]); $p++) { print '_'; }
if( $split_label[1] eq '???' or $split_label[1] eq '') { 

my @temp = split(' ', ` ./step12.pl | grep '$Names[$_[2]]'; `); $split_label[1] =  $temp[-1]; 

#print RED, $Names[$_[2]], RESET, "\n";
#print BLUE, $temp[-1], RESET, "\n";


} print  $split_label[1], ",\n";
}

$tracker{$_[0]} = 1;
$tracker{$_[2]} = 1;

#########################################################################

$file[-2] =~ s/\($line[$loop]\)/\($line[$loop]\)$label/g;

}

} }

while( my( $key, $value ) = each %tracker ){
#    print "$key: $value\n";
}

#print "@Names\n";

for(my $m=1; $m<@Names; $m++) {
if (exists $tracker{$m} ) { } else { unless ($Names[$m] eq 'void') { print $m, "\t", $Names[$m]; 

for(my $p=0; $p<30-(length $Names[$m]); $p++) { print '_'; }
my @temp = split(' ', ` ./step12.pl | grep '$Names[$m]';` );
print $temp[-1];
print "\n";

} }
}

print "\t;", "\n";

print $file[-2], "\n";
chomp $file[-1];
print $file[-1], "\n";
exit;

