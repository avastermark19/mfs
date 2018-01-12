#! /usr/bin/perl -w
use strict;

###########################################################################################

#print STDERR 'Jackhmmr workflow... ', "\n";

#exit;

###########################################################################################

my @input;

print STDERR "Do you want to extract HMMs (y/N): ";
 $input[1] = <STDIN>;
chomp $input[1];
$input[1] =lc ($input[1]);
if($input[1] ne 'y') { $input[1] = 'n';}

print STDERR "Do you want to run TOPCONS (y/N): ";
 $input[2] = <STDIN>;
chomp $input[2];
$input[2] =lc ($input[2]);
if($input[2] ne 'y') { $input[2] = 'n';}

print STDERR "Do you want to run CONS (y/N): ";
 $input[5] = <STDIN>;
chomp $input[5];
$input[5] =lc ($input[5]);
if($input[5] ne 'y') { $input[5] = 'n';}

print STDERR "Do you want to run JACKHMMR (y/N): ";
 $input[7] = <STDIN>;
chomp $input[7];
$input[7] =lc ($input[7]);
if($input[7] ne 'y') { $input[7] = 'n';}

###########################################################################################

#print STDERR 'Jackhmmr workflow... ', "\n";
` rm -rf TOPCONS/ `;
` rm -rf CONS/ `;
` rm -rf REPEAT/ `;
` rm -rf CLUSTER/ `;
` rm -rf step11.out `;
` rm -rf step6.out `;
` rm -rf STEP7_COMPLETED `;
` rm -rf TREE_COI.nex `;


###########################################################################################

#print "@input" , "\n";

if($input[1] eq 'y') { 
print STDERR 'Extracting ... ', "\n";
` ./step1.pl > /dev/null 2>&1 ` 
}

###########################################################################################

if($input[2] eq 'y') { print STDERR 'Predicting '; ` ./step2.pl `; print "\n"; } else {
` mkdir TOPCONS `;
print STDERR 'Coping top. output ... ', "\n";
` cp -R BACKUP/* TOPCONS/ `;
}

###########################################################################################

print STDERR 'Making clusters ... ', "\n";
` ./step3.pl > /dev/null 2>&1 `;

###########################################################################################

print STDERR 'Making tree ... ', "\n";
` ./step4.pl > /dev/null 2>&1 `;

###########################################################################################

if($input[5] eq 'y') { print STDERR 'Making cons ... ', "\n"; ` ./step5.pl > /dev/null 2>&1 ` } else {
` mkdir CONS `;
print STDERR 'Coping cons. output ... ', "\n";
` cp -R BACKUP_CONS/* CONS/ `;
}

###########################################################################################

print STDERR 'Making labels ...', "\n";
` ./step6.pl > step6.out `;

print STDERR 'Reformatting ...', "\n";
` ./step10.pl > temp; mv temp step6.out `;

print STDERR 'Building evolutionary models ...', "\n";
` ./step11.pl > step11.out `;

###########################################################################################

if($input[7] eq 'y') { 

print STDERR 'Iterating ... ', "\n";
` ./step7.pl  > /dev/null 2>&1   ` 
} 

###########################################################################################

print STDERR 'Making final tree ... ', "\n";
` ./step4.pl > /dev/null 2>&1 `;

print STDERR 'Displaying labels on tree', "\n";
my @output = ` ./step8.pl `;

print @output, "\n";

###########################################################################################

exit;

