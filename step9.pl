#!/usr/bin/perl -w
use strict;
  use Term::ANSIColor qw(:constants);

# PRECOMPUTE CONS SEQUENCES

print '#NEXUS ', "\n";
print 'Begin data;', "\n";

open(FILE, ">temp.fa");
my @dir = ` ls CLUSTER `;
for(my $i=0; $i<@dir; $i++) {
 chomp $dir[$i];
 print FILE '>'.$dir[$i], "\n";
 my @Q = split(' ', ` grep '^Q ' CLUSTER/$dir[$i]/HHALIGN/$dir[$i].hhalign | grep -v 'Consensus' `);
 for(my $i=6; $i<@Q; $i+=3) { $Q[3] .= $Q[$i]; }
 print FILE $Q[3], "\n";
}
close(FILE);

##############################################################



# print RED, $_, RESET, "\n";



##############################################################

` mafft --quiet temp.fa > temp.aln `;
#` rm -f temp.fa `;


##############################################################

my @aln  = ` cat temp.aln `;
my $seq ='';
for(my $loop=0; $loop<@aln; $loop++) {
 chomp $aln[$loop];
 my @line = split('', $aln[$loop]);
  if($line[0] eq '>') {
   if($seq ne '') {  $seq=''; }
  }
 else { $seq .= $aln[$loop]; }
}

#print GREEN, length $seq, RESET, "\n";

$_= ` grep '>' temp.fa  | wc -l `;
chop ; chomp ;


print '    Dimensions ntax='.$_.' nchar='.(length $seq).';', "\n";
print '    Format datatype=protein gap=-;', "\n";
print '    Matrix', "\n";


##############################################################

 @aln  = ` cat temp.aln `;
 $seq ='';
for(my $loop=0; $loop<@aln; $loop++) {
 chomp $aln[$loop];
 my @line = split('', $aln[$loop]);
  if($line[0] eq '>') {
   if($seq ne '') { print $seq, "\n"; $seq=''; }
   print @line[1 .. $#line], "\t";
  } 
 else { $seq .= $aln[$loop]; }
}

print $seq, "\n";
print '   ;', "\n";
print 'End; ', "\n";


` rm -f temp.fa `; 
` rm -f temp.aln `;

exit;

