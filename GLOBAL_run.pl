#! /usr/bin/perl -w
use strict;

#################################### THIS IS AN INTERFACE OF LOCAL_RUN INTERFACE

# THIS IS A TEST VERSION THAT ASSUMES YOU ALREADY HAVE THE NECESSARY TOPCONS FILES IN BACKUP/
# THE RELEASE VERSION, YOU NEED TO MAKE 2 CHANGES BELOW

####################################

system("clear");
print '***BlueSky Research March2018***', "\n";

print 'Nucleic Acids Res. 2016 Jan 4; 44(Database issue): D372–D379. ', "\n";
print '    1. ABC_membrane (CL0241), maybe 2
    2. ABC-2 some kind of 3+3? (CL0181)
    3. IT (Ion Transporter) superfamily, CL0182 6+6
    4. CopD Like (CL0430), 4+4?
    5. Holins (CL0562,3,4), maybe 3?
    6. LysE (CL0292), maybe 3
    7. PTS_EIIC (CL0493), maybe 5
    8. RND permease (CL0322), maybe 6', "\n";

my @input;

DIE1:
print STDERR "[ CL0062=APC, CL0184=DMT, CL0064=CPA_AT, CL0015=MFS ]\n";
print STDERR "Do you want to RESET ONLY (CL0062,,/default=MFS): ";
 $input[0] = <STDIN>;
chomp $input[0];
$input[0] =uc ($input[0]);
if($input[0] eq '') { $input[0] = 'CL0015';}
if($input[0] ne 'CL0015') { if($input[0] ne 'CL0184') { if($input[0] ne 'CL0062') { if($input[0] ne 'CL0064') { goto DIE1; } } } }

die2:
print STDERR "Which repeat unit do you want to try (e.g. 4,5 /default=6): ";
 $input[1] = <STDIN>;
chomp $input[1];
$input[1] =uc ($input[1]);
if($input[1] eq '') { $input[1] = 6;}
if($input[1] != 4) { if($input[1] != 5) { if($input[1] != 6) { goto die2; } } }

die3:
print STDERR "Which level of TOPCONS granularity (e.g. 1,3,4 /default=2) [The higher the number, the more less stringent clusters.]: ";
 $input[2] = <STDIN>;
chomp $input[2];
$input[2] =uc ($input[2]);
if($input[2] eq '') { $input[2] = 2;}
if($input[2] != 1) { if($input[2] != 2) { if($input[2] != 3) { if($input[2] != 4 ) { goto die3; } } } }

print 'The current settings are : ', $input[0], ' ', $input[1], ' ', $input[2], "\n";
print 'Typical settings could be: MFS 6 2', "\n";
print "\n";

#################################### REPRINTING OPS

` ./LOCAL_run.pl ynnnn `; 
` rm -f *.out `;
`  rm -rf BACKUP_CONS `;
` rm -f domtblout.txt `;
` rm -f MFS.hmm `;
` rm -f APC.hmm `;
` rm -f DMT.hmm `;
` rm -f CPA_AT.hmm `;


#################################### SPECIAL DELETION CURRENTLY OFF, SHOULD BE ON IN DELIVERED VERSION
#` rm -rf BACKUP/ `; 

####################################

#################################### REPRINTING

` head -n 49  step3.pl > step3.temp `;
` echo '' >> step3.temp `;
open(FILE, ">>step3.temp");
if ( $input[2] == 1 ) {
print FILE 'if( split( /1{$CUTOFF_UNSAFE,}|2{$CUTOFF_UNSAFE,}|3{$CUTOFF_UNSAFE,}|4{$CUTOFF_UNSAFE,}/ , $seq) > 1 ) {  ` rm -rf TOPCONS/$DIR `; $DISCARDED_UNSAFE++; } else {', "\n\n" ;
}

if( $input[2] ==2 ) {
print FILE 'if( split( /1{$CUTOFF_UNSAFE,}|2{$CUTOFF_UNSAFE,}|3{$CUTOFF_UNSAFE,}/ , $seq) > 1 ) {  ` rm -rf TOPCONS/$DIR `; $DISCARDED_UNSAFE++; } else {', "\n\n" ;
}

if( $input[2]  ==3 ) {
print FILE 'if( split( /1{$CUTOFF_UNSAFE,}|2{$CUTOFF_UNSAFE,}/ , $seq) > 1 ) {  ` rm -rf TOPCONS/$DIR `; $DISCARDED_UNSAFE++; } else {' , "\n\n";
}

if( $input[2]  ==4 ) {
print FILE 'if( split( /1{$CUTOFF_UNSAFE,}/ , $seq) > 1 ) {  ` rm -rf TOPCONS/$DIR `; $DISCARDED_UNSAFE++; } else {' , "\n\n";
}


close(FILE);

`tail -n 53 step3.pl >> step3.temp `;
` mv step3.temp step3.pl `;
` chmod u+x step3.pl `;

#if( split( /1{$CUTOFF_UNSAFE,}|2{$CUTOFF_UNSAFE,}|3{$CUTOFF_UNSAFE,}|4{$CUTOFF_UNSAFE,}/ , $seq) > 1 ) {  ` rm -rf TOPCONS/$DIR `; $DISCARDED_UNSAFE++; } else {
#if( split( /1{$CUTOFF_UNSAFE,}|2{$CUTOFF_UNSAFE,}|3{$CUTOFF_UNSAFE,}/ , $seq) > 1 ) {  ` rm -rf TOPCONS/$DIR `; $DISCARDED_UNSAFE++; } else { 
#if( split( /1{$CUTOFF_UNSAFE,}|2{$CUTOFF_UNSAFE,}/ , $seq) > 1 ) {  ` rm -rf TOPCONS/$DIR `; $DISCARDED_UNSAFE++; } else {

#################################### REPRINTING

open(FILE, ">config.temp");
print FILE 'WhichClan1 ', $input[0], "\n";
close(FILE);

` head -n 6 config.file | tail -n 5 >> config.temp `;

open(FILE, ">>config.temp");
print FILE 'REPEAT_UNIT_SETTING ', $input[1], "\n";
print FILE 'setting 8', "\n\n";
close(FILE);

` mv config.temp config.file `;

#################################### REPRINTING

 ` ./LOCAL_run.pl nynyy `; ## THIS IS A SPECIAL NON RELEASED SETTING WHERE YOU DO NOT RUN TOPCONS-- FOR TESTING ONLY
#` ./LOCAL_run.pl nyyyy `; ## THIS IS FOR THE END USER

####################################

exit;

