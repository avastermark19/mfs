#!/usr/bin/perl -w
use strict;

#ENCODE TEMPLATE 5+5#######################################################
my $template1=6;
my $template2=6;
#ENCODE TEMPLATE 5+5#######################################################

if ( $ARGV[0] ) {

my $SPACE = $ARGV[0];

my $half_SPACE ;

if (0 == $SPACE % 2) {
 $half_SPACE = $SPACE/2;
} else {
$half_SPACE = ($SPACE-1)/2;
}

#print $SPACE, "\n";
#print $half_SPACE, "\n";
#print '+++++++++++++++++++++++++++++++++++++', "\n";

if( $SPACE == $template1+$template2 ) { print '0+'.$template1.'+0+'.$template2.'+0', "\n"; }

if( $SPACE == $template1+$template2+1 ) {
print '1+'.$template1.'+0+'.$template2.'+0', "\n";
print '0+'.$template1.'+1+'.$template2.'+0', "\n";
print '0+'.$template1.'+0+'.$template2.'+1', "\n";
}

if( $SPACE == $template1+$template2+2 ) {
print '2+'.$template1.'+0+'.$template2.'+0', "\n";
print '0+'.$template1.'+2+'.$template2.'+0', "\n";
print '0+'.$template1.'+0+'.$template2.'+2', "\n";
}

if( $SPACE == $template1+$template2-1 ) {
print '0+'.($template1-1).'+0+'.$template2.'+0', "\n";
print '0+'.$template1.'+0+'.($template2-1).'+0', "\n";
}

if( $SPACE == $template1+$template2-2 ) {
print '0+'.($template1-2).'+0+'.$template2.'+0', "\n";
print '0+'.$template1.'+0+'.($template2-2).'+0', "\n";
}


} else { print 'ARGV', "\n"; }

exit;


