#SIMPLE_run.pl
#./step1.pl
#./step2.pl
# assumes at this point you have TOPCONS/ ready
./step3.pl
./step15.pl
./step4.pl
./step5.pl
./step6.pl > step6.out
./step10.pl > temp; mv temp step6.out
./step13.pl
./step11.pl a > step11.out
./step11.pl b > step11b.out
./step12.pl b > step12b.out
./step7.pl
./step4.pl
./step8.pl

