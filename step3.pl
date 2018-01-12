#!/usr/bin/perl -w
use strict;
   use Term::ANSIColor qw(:constants);

` rm -f STEP7_COMPLETED `;
` cp -R BACKUP/* TOPCONS/ `;   # BACK UP 

## PARAMETER ##
my $CUTOFF_UNSAFE=   upcase_in(2);   # 12;    # USED TO BE 5 !! ( BUT THIS IS NOT THE ACTUAL -- SEE BELOW )
my $CUTOFF_TMS =     upcase_in(3);     # 5;      # used to be 6 
my $CUTOFF_MEMBERS = upcase_in(4);    # 4;  # used to be 5

my $DISCARDED_UNSAFE=0;
my $DISCARDED_TMS = 0;
my $DISCARDED_MEMBERS=0;

###############
` rm -rf CLUSTER `;
` mkdir CLUSTER `;


my %cluster;
foreach my $DIR (` ls TOPCONS/ `) {
chomp $DIR;
print STDERR '.';

my $seq='';

my @TOPCONS = split('',    ` grep -A 1 '^TOPCONS '     TOPCONS/$DIR/seq_0/query.result.txt | tail -n 1 `);  pop @TOPCONS;
my @TOPCONZ = split(/M+/,  ` grep -A 1 '^TOPCONS '     TOPCONS/$DIR/seq_0/query.result.txt | tail -n 1 `);  pop @TOPCONZ;
my @Philius     = split('',` grep -A 1 '^Philius '     TOPCONS/$DIR/seq_0/query.result.txt | tail -n 1 `);  pop @Philius;
my @SCAMPI      = split('',` grep -A 1 '^SCAMPI '      TOPCONS/$DIR/seq_0/query.result.txt | tail -n 1 `);  pop @SCAMPI;
my @SPOCTOPUS   = split('',` grep -A 1 '^SPOCTOPUS '   TOPCONS/$DIR/seq_0/query.result.txt | tail -n 1 `); pop @SPOCTOPUS; 
my @OCTOPUS     = split('',` grep -A 1 '^OCTOPUS '     TOPCONS/$DIR/seq_0/query.result.txt | tail -n 1 `); pop @OCTOPUS; 
my @PolyPhobius = split('',` grep -A 1 '^PolyPhobius ' TOPCONS/$DIR/seq_0/query.result.txt | tail -n 1 `);  pop @PolyPhobius;

for(my $i=0; $i<@TOPCONS; $i++){
my $M=0;

if($Philius[$i] eq 'M') { $M++;  }
if($SCAMPI[$i] eq 'M') { $M++;  }
if($SPOCTOPUS[$i] eq 'M') { $M++;  }
if($OCTOPUS[$i] eq 'M') { $M++;  }
if($PolyPhobius[$i] eq 'M') { $M++;  }

$seq .= $M;

}

#if( split( /1{$CUTOFF_UNSAFE,}|2{$CUTOFF_UNSAFE,}|3{$CUTOFF_UNSAFE,}/ , $seq) > 1 ) {  ` rm -rf TOPCONS/$DIR `; $DISCARDED_UNSAFE++; } else { 
 if( split( /1{$CUTOFF_UNSAFE,}|2{$CUTOFF_UNSAFE,}/ , $seq) > 1 ) {  ` rm -rf TOPCONS/$DIR `; $DISCARDED_UNSAFE++; } else {

# GO ON #
if(scalar @TOPCONZ < $CUTOFF_TMS) { ` rm -rf TOPCONS/$DIR `; $DISCARDED_TMS++; } else {
# GO ON #
my @line = split(' ', ` grep '$DIR' domtblout.txt | sort -n -k8,8 | tail -n 1 ` ) ;
$cluster{$line[3].'_'.(scalar @TOPCONZ)} .= $DIR.'_';

} # ELSE

 }; # ELSE

} # FOREACH 

print STDERR "\n";

##############################################################################################################################

foreach my $key (keys(%cluster)) { 
my @line = split('_', $cluster{$key});
if( @line > $CUTOFF_MEMBERS ) { 
print $key, "\t", "@line", "\n"; 

# GO ON #

` rm -rf CLUSTER/$key `;
` mkdir CLUSTER/$key `;
` mkdir CLUSTER/$key/HHALIGN `;

foreach my $member (@line) {

` echo ">$member" >> CLUSTER/$key/seq.fa `;
` cat TOPCONS/$member/seq_0/seq.fa | tail -n 1 >> CLUSTER/$key/seq.fa `;
` echo  >> CLUSTER/$key/seq.fa `;

}

my $stack = ` mafft CLUSTER/$key/seq.fa > CLUSTER/$key/seq.aln `;                    # DONT THINK STACK IS USED 
   $stack =` hhmake -i CLUSTER/$key/seq.aln -M 50 -nocontxt -cons `;

}  else { $DISCARDED_MEMBERS++; }
}

##############################################################################################################################

print 'DISCARDED_UNSAFE=', $DISCARDED_UNSAFE, "\n";
print 'DISCARDED_TMS=', $DISCARDED_TMS, "\n";
print 'DISCARDED_MEMBERS=', $DISCARDED_MEMBERS, "\n";

exit;

  sub upcase_in { return (split(' ', ` head -n $_[0] config.file | tail -n 1 `))[1]; }


