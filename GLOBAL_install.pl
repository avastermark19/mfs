#! /usr/bin/perl -w
use strict;
    use Term::ANSIColor qw(:constants);

system("clear");

print 'git clone https://github.com/avastermark19/mfs', "\n";
print 'git status', "\n";

my $internet = (split(' ', ` ping -c 1 goole.com `))[0];
if($internet eq 'PING') { print ON_RED, 'Internet OK', RESET, "\n"; } else { print 'Check your internet connection', "\n"; exit; }

print RED, "Downloading";
` wget -nc -q "ftp://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam31.0/Pfam-A.clans.tsv.gz" `;
print RED, '.';
` wget -nc -q "ftp://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam31.0/Pfam-A.hmm.gz" `;
print RED, '.';
` wget -nc -q "ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz" `;
print RED, '.';
` wget -nc -q "http://topcons.net/static/download/script/topcons2_wsdl.py" `;
print RED, '.';
` wget -nc -q "https://zhanglab.ccmb.med.umich.edu/TM-align/TMalign.gz" `;
print RED, '.', RESET, "\n";
print BLUE, 'Unpacking... ', "\n", RESET;
` gunzip *.gz; `;

if( -e "Pfam-A.clans.tsv" ) {} else { print ' Pfam file 1 missing ', "\n"; exit; }
if( -e "Pfam-A.hmm" ) {} else { print ' Pfam file 2 missing ', "\n"; exit; }

DIE1:

` chmod u+x *.pl `;
` chmod u+x *.exe `;
` chmod u+x TMalign `;

#ping R
` echo "q();" > temp.R `;
my $R_ping= (split(' ', ` R --vanilla < temp.R ` ))[0] ;
` rm temp.R `;
if( $R_ping eq 'R' ) { print GREEN, 'Successfully Pinged R ', RESET, "\n"; } else { print 'R did not ping', "\n"; }

#ping Python
` echo "print('Python');" > temp.py `;
my $Py_ping = (split(' ', ` python temp.py ` ))[0] ;
` rm temp.py `;
if( $Py_ping eq 'Python' ) { print GREEN, 'Successfully Pinged Python ', RESET, "\n"; } else { print 'Python did not ping', "\n"; }

# ping hmmer
` hmmscan 2>&1 > hmmscan.temp  `; 
my $hmmer_ping = (split(' ', ` cat hmmscan.temp ` ))[0] ;
if( $hmmer_ping and $hmmer_ping eq 'Incorrect' ) { print GREEN, 'Successfully Pinged hmmer ', RESET, "\n"; } 
 else { 
print RED, 'try: sudo apt-get install hmmer', RESET, "\n";
}
` rm hmmscan.temp  `;

# ping hhsuite
` hhalign 2>&1 > hhalign.temp  `;
my $hhsuite_ping = (split(' ', ` cat hhalign.temp ` ))[0] ;
if( $hhsuite_ping and $hhsuite_ping eq 'HHalign' ) { print GREEN, 'Successfully Pinged hhsuite ', RESET, "\n"; }
 else {
print RED, 'try: sudo apt-get install hhsuite', RESET, "\n";
}
` rm hhalign.temp  `;

#ping mb
` echo "quit;" > temp.mb `;
` mb temp.mb 2>&1 > temp2.mb  `;
my $mb_ping = (split(' ', ` cat temp2.mb ` ))[0] ;
if( $mb_ping and $mb_ping eq 'MrBayes' ) { print GREEN, 'Successfully Pinged mb ', RESET, "\n"; }
 else {
print RED, 'try: sudo apt-get install mrbayes', RESET, "\n";
}
` rm temp2.mb `;
` rm temp.mb `;

exit;

