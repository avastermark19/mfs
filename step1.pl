#! /usr/bin/perl -w
use strict;
  use Term::ANSIColor qw(:constants);

my $clan;

if($ARGV[0]) { $clan = $ARGV[0]; } else { $clan = upcase_in(1); }

# FILES NEEDED
# -rw-r--r-- 1 aake aake     963417 dec  4 11:00 Pfam-A.clans.tsv
# -rw-r--r-- 1 aake aake 1372159421 dec  4 10:55 Pfam-A.hmm
# -rw-r--r-- 1 aake aake  268833358 dec  4 10:47 uniprot_sprot.fasta (ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz)
#PARAMETER

if ( ` cat Pfam-A.clans.tsv | awk '\$2 == \"$clan\"' `  ) {} else { print 'warning: INVALID CLAN', "\n"; exit; }

print STDERR ON_RED, $clan, RESET, "\t";
#END 

open(FILE, "Pfam-A.clans.tsv");
my @file = <FILE>;
close(FILE);

my @list;
foreach my $line (@file) {
 my @array = split(' ', $line);
 if($array[1] eq $clan) { push @list, $array[3]; }
}

print STDERR scalar @list, "\n";

## GET HMMS FOR THESE

` rm -f $clan.hmm `;
foreach my $hmm (@list) { 



` echo 'HMMER3/f [3.1b2 | February 2015]'  >> $clan.hmm `;
print STDERR "sed -n -e '/$hmm/,/\\/\\// p' Pfam-A.hmm >> $clan.hmm\n";
` sed -n -e  '/NAME  $hmm\$/,/\\/\\// p' Pfam-A.hmm >> $clan.hmm `; 

}

# GET SEQUENCES

print STDERR 'hmmsearch  --domtblout domtblout.txt $clan.hmm uniprot_sprot.fasta', "\n";
` time hmmsearch  --domtblout domtblout.txt $clan.hmm uniprot_sprot.fasta  `;







exit;

    sub upcase_in { return (split(' ', ` head -n $_[0] config.file | tail -n 1 `))[1]; }


