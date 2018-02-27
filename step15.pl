#! /usr/bin/perl -w
use strict;

my @cluster = ` ls CLUSTER/ `;

for(my $i=0; $i<@cluster; $i++) {

my @line = split('_', $cluster[$i] );

if($line[0] eq '') {
chomp $cluster[$i];

`rm -rf CLUSTER/$cluster[$i] `;

}

}

exit;


