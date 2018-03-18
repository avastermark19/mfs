#!/usr/bin/perl -w
use strict;
use Term::ANSIColor qw(:constants);

# R version 3.4.2 (2017-09-28) -- "Short Summer"

my @dir;
if( $ARGV[0] ) { @dir = ` ls $ARGV[0]/ `; } else {
@dir = ` ls TOPCONS/ `;
}

#print scalar @dir, "\n";

my %hash;

my @array;

my $sum=0;

for(my $j=0; $j<20; $j++) { $hash{$j}=0; } # ini

for(my $i=0; $i<@dir; $i++) {

chomp $dir[$i];


my @TOPCONS;
if( $ARGV[0] ) { 
@TOPCONS = split(/M+/, ` grep -A 1 '^TOPCONS ' $ARGV[0]/$dir[$i]/query.result.txt | tail -n 1 `);
} else {
@TOPCONS = split(/M+/, ` grep -A 1 '^TOPCONS ' TOPCONS/$dir[$i]/query.result.txt | tail -n 1 `);
}

#my @TOPCONS_Q = split('',    ` grep -A 1 '^TOPCONS '     CONS/$dir[$i]/seq_0/query.result.txt | tail -n 1 `);

shift @TOPCONS;

my $TMS = scalar @TOPCONS;

#print $TMS, "\n";

$hash{$TMS}++;
$sum++;

push @array, $TMS;

}

#######################################################

open(FILE1, ">test1.r");

print FILE1 'r=c(';

for(my $i=0; $i<@array-1; $i++) {

print FILE1 $array[$i],',';

}

print FILE1 $array[-1];

print FILE1 ')', "\n";

print FILE1 'library(mixtools)', "\n";
print FILE1 'mixmdl = normalmixEM(r)', "\n";
print FILE1 'mixmdl', "\n";
print FILE1 '#plot(mixmdl,which=2)', "\n";

close(FILE1);

print 'finite Gaussian mixture distribution', "\n";

print (` R --vanilla < test1.r | grep -A 10 'lambda' `);

#######################################################
#######################################################

# RawData
#foreach my $key ( sort { $a <=> $b }  keys %hash)
#{
#  my $value = $hash{$key};
#  print RED, $key, RESET, " ";
# print ON_RED, $value, RESET, "\n";
#}

#######################################################

print 'fit a single Gaussian using non-linear least squares', "\n";

open(FILE2, ">test2.r");

print FILE2 'r=c(';

my $con='';

foreach my $key ( sort { $a <=> $b }  keys %hash)
{
  my $value = $hash{$key};
# print FILE2 ($value/$sum)+rand()/10, ',';
$con .= ($value/$sum)+rand()/10;
$con .= ',';
}

chop $con;

print FILE2 $con, ')', "\n";

print FILE2 'tab <- data.frame(x=seq_along(r), r=r)', "\n";
print FILE2 '(res <- nls( r ~ k*exp(-1/2*(x-mu)^2/sigma^2), start=c(mu=12,sigma=1,k=2) , data = tab))', "\n";

print FILE2 '#v <- summary(res)$parameters[,"Estimate"]', "\n";
print FILE2 '#plot(r~x, data=tab)', "\n";
print FILE2 '#plot(function(x) v[3]*exp(-1/2*(x-v[1])^2/v[2]^2),col=2,add=T,xlim=range(tab$x) )', "\n";

close(FILE2);

print (` R --vanilla < test2.r | grep -A 8 'Nonlinear' `);

#######################################################

print 'residual sum-of-squares: 0.1051 (a good fit for the single Gaussian)', "\n";
print 'residual sum-of-squares: 0.6554 (BAD)', "\n";

print 'A distribution is considered to have a double peak if the following applies: 1) the bitopic Gaussian fits better than the monotopic Gaussian (lower χ2-value), 2) the μ-values of the bitopic Gaussian differ more than 2.5, 3) the σ-values of the bitopic Gaussian are lower than 0.7 and 4) the TM-segment frequency corresponding to the peaks of the bitopic Gaussian are greater than 0.05', "\n";

print 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3009398/figure/fig06/', "\n";

exit;


