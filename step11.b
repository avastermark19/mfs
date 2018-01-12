#!/usr/bin/perl -w
use strict;

if ( $ARGV[0] ) {

my $SPACE = $ARGV[0];

my $half_SPACE ;

if (0 == $SPACE % 2) {
 $half_SPACE = $SPACE/2;
} else {
$half_SPACE = ($SPACE-1)/2;
}

#print $SPACE, "\n";
#print '+++++++++++++++++++++++++++++++++++++', "\n";

 if (0 == $SPACE % 2) {  
#print $half_SPACE.'+'.$half_SPACE, "\t";
print '0+'.$half_SPACE.'+0+'.$half_SPACE, '+0', "\n";

#print '2+'.($half_SPACE-1).'+'.($half_SPACE-1), "\t";
print '2+'.($half_SPACE-1).'+0+'.($half_SPACE-1)."+0", "\n";

#print (($half_SPACE-1).'+2+'.($half_SPACE-1), "\t");
print ('0+'.($half_SPACE-1).'+2+'.($half_SPACE-1).'+0', "\n");

#print (($half_SPACE-1).'+'.($half_SPACE-1).'+2', "\t");
print ('0+'.($half_SPACE-1).'+0+'.($half_SPACE-1).'+2', "\n");
} else {

print '1+'.($half_SPACE).'+0+'.($half_SPACE). '+0', "\n";
print ('0+'.($half_SPACE).'+1+'.($half_SPACE).'+0', "\n");
print ('0+'.($half_SPACE).'+0+'.($half_SPACE).'+1', "\n");



}

} else { print 'ARGV', "\n"; }

exit;


