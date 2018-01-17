#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#define M_PI 3.14159265358979323846
int main (  int argc, char *argv[]   ) { srand((unsigned int)time(NULL));
FILE* myfile_A;
FILE* myfile_B;
myfile_A=fopen(argv[1],"r");
myfile_B=fopen(argv[2],"r");
int i;
int N=0;
float arr_A[999][3], arr_B[999][3];
while(!feof(myfile_A)) { if(fgetc(myfile_A) == '\n') { N++; } }
rewind(myfile_A);
for(i = 0; i < N; i++){ fscanf(myfile_A, "%f %f %f", &arr_A[i][0], &arr_A[i][1], &arr_A[i][2]); fscanf(myfile_B, "%f %f %f", &arr_B[i][0], &arr_B[i][1], &arr_B[i][2]); }
fclose(myfile_A); fclose(myfile_B);
float avg_A0=0, avg_A1=0, avg_A2=0, avg_B0=0, avg_B1=0, avg_B2=0;
for(i = 0; i < N; i++){ avg_A0 += arr_A[i][0]; avg_A1 += arr_A[i][1]; avg_A2 += arr_A[i][2];
avg_B0 += arr_B[i][0]; avg_B1 += arr_B[i][1]; avg_B2 += arr_B[i][2]; }
avg_A0 /= N; avg_A1 /= N; avg_A2 /= N; avg_B0 /= N; avg_B1 /= N; avg_B2 /= N;
for(i = 0; i < N; i++){ arr_B[i][0] += avg_A0-avg_B0; arr_B[i][1] += avg_A1-avg_B1; arr_B[i][2] += avg_A2-avg_B2; }
float RMSD, min_RMSD=99999, loop;
float rotation_0, rotation_1, rotation_2, new_0, new_1, new_2; 
for(loop = 0; loop < 10000; loop++){ 
rotation_0 =  ( ((float)rand()/(float)(RAND_MAX))*360      *M_PI)/180;
rotation_1 =  ( ((float)rand()/(float)(RAND_MAX))*360      *M_PI)/180;
rotation_2 =  ( ((float)rand()/(float)(RAND_MAX))*360      *M_PI)/180;
for(i = 0; i < N; i++){ new_0 = arr_A[i][0] * cos(rotation_2) - arr_A[i][1] * sin(rotation_2); new_1 = arr_A[i][1] * cos(rotation_2) + arr_A[i][0] * sin(rotation_2); arr_A[i][0]=new_0; arr_A[i][1]=new_1; }
for(i = 0; i < N; i++){ new_0 = arr_A[i][0] * cos(rotation_1) - arr_A[i][2] * sin(rotation_1); new_2 = arr_A[i][2] * cos(rotation_1) + arr_A[i][0] * sin(rotation_1); arr_A[i][0]=new_0; arr_A[i][2]=new_2; }
for(i = 0; i < N; i++){ new_1 = arr_A[i][1] * cos(rotation_0) - arr_A[i][2] * sin(rotation_0); new_2 = arr_A[i][2] * cos(rotation_0) + arr_A[i][1] * sin(rotation_0); arr_A[i][1]=new_1; arr_A[i][2]=new_2; }
RMSD=0; for( i=0; i<N; i++) { RMSD += pow ( sqrt (  pow( arr_A[i][0]-arr_B[i][0], 2) + pow (arr_A[i][1]-arr_B[i][1],2) + pow(arr_A[i][2]- arr_B[i][2],2)  )                  , 2 ); }
RMSD= sqrt(((float) 1/N)*RMSD); if ( RMSD < min_RMSD ) { min_RMSD = RMSD; } }
printf("%f\n", min_RMSD);
return 0;
}

