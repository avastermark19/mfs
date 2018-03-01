#! /usr/bin/perl -w
use strict;

my $internet = (split(' ', ` ping -c 1 goole.com `))[0];
if($internet eq 'PING') { print 'Internet OK', "\n"; } else { print 'Check your internet connection', "\n"; exit; }

` cp ~/mfs/Pfam-A* . `;
` cp ~/mfs/uniprot* . `;
` cp ~/mfs/topcons* . `;
` cp ~/mfs/TMalign* . `;

` chmod u+x *.pl `;
` chmod u+x *.exe `;

` chmod u+x TMalign `;

exit;

