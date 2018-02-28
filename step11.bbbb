#!/usr/bin/perl -w
use Term::ANSIColor qw(:constants);
use strict;

####################################################
my $template1=upcase_in(7);
my $template2=upcase_in(7);
#ENCODE TEMPLATE 5+5#######################################################

if ( $ARGV[0] and $ARGV[1] and ($ARGV[1] eq 'b' or $ARGV[1] eq 'bb' or $ARGV[1] eq 'bbb')) { #14
my $SPACE = $ARGV[0];
my $half_SPACE ;
if (0 == $SPACE % 2) { $half_SPACE = $SPACE/2; } else { $half_SPACE = ($SPACE-1)/2; }

### SAME FOR ALL MODES

if( $ARGV[1] eq 'bbb' ) {
for( my $incr=2; $incr < $half_SPACE + 1; $incr++) { # repeat unit must be longer than 1
my $residual = $ARGV[0]-(2*$incr);
if( $residual > 0) { for( my $A_incr = $residual ; $A_incr >= 0; $A_incr-- ) {
my $A_residual = $residual - $A_incr; if( $A_residual > 0 ) {
for( my $B_incr = $A_residual ; $B_incr >= 0; $B_incr-- ) {
my $B_residual = $A_residual - $B_incr; if ( $B_residual > 0 ) {
for( my $C_incr = $B_residual ; $C_incr >= 0; $C_incr-- ) {
if ( $A_incr + $B_incr + $C_incr == $residual ) { print $A_incr, '+', $incr, '+', $B_incr, '+', $incr, '+', $C_incr, "\n"; }
} } else {
if ( $A_incr + $B_incr == $residual ) { print $A_incr, '+', $incr, '+', $B_incr, '+', $incr, '+0', "\n"; }
} } } else { if ( $A_incr == $residual ) { print   $A_incr, '+', $incr, '+0+', $incr, '+0', "\n"; }
} } } else { print '0+', $incr, '+0+', $incr, '+0', "\n"; } } 
} # bbb mode

if( $ARGV[1] eq 'bb' ) {
if( $SPACE == $template1+$template2 ) { print '0+'.$template1.'+0+'.$template2.'+0', "\n"; }
if( $SPACE == $template1+$template2+1 ) { print '1+'.$template1.'+0+'.$template2.'+0', "\n"; 
print '0+'.$template1.'+1+'.$template2.'+0', "\n"; print '0+'.$template1.'+0+'.$template2.'+1', "\n"; }
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
} # bb mode

if( $ARGV[1] eq 'b' ) {
if (0 == $SPACE % 2) {  
print '0+'.$half_SPACE.'+0+'.$half_SPACE, '+0', "\n";
print '2+'.($half_SPACE-1).'+0+'.($half_SPACE-1)."+0", "\n";
print ('0+'.($half_SPACE-1).'+2+'.($half_SPACE-1).'+0', "\n");
print ('0+'.($half_SPACE-1).'+0+'.($half_SPACE-1).'+2', "\n");
} else {
print '1+'.($half_SPACE).'+0+'.($half_SPACE). '+0', "\n";
print ('0+'.($half_SPACE).'+1+'.($half_SPACE).'+0', "\n");
print ('0+'.($half_SPACE).'+0+'.($half_SPACE).'+1', "\n");
}
} # b mode

### SAME FOR ALL MODES
} else { print 'ARGV', "\n"; }

exit;
sub upcase_in { return (split(' ', ` head -n $_[0] config.file | tail -n 1 `))[1]; }

