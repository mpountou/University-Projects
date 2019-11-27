#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

void writeBinary( char *name, int *list, int nElem)
{
  FILE *write_ptr = fopen(name,"wb");
  fwrite(list, sizeof(int), nElem, write_ptr);
  fclose( write_ptr);
}

int cmpfunc (const void * a, const void * b) {
  return ( *(int*)a - *(int*)b );
}


void sortAllListsFork(int **numbers, int nList, int nElem){
  int arr[nList][nElem];
  char str[9];
  char *name;
  int *list;
  int pid;


  for(int i=0; i<nList; i++){
    pid=fork();
    if(pid==0){
      for(int j=0; j<nElem; j++){
        arr[i][j] = *( *numbers + i*nElem + j );
      }
      qsort(arr[i], nElem, sizeof(int), cmpfunc);
      for (int j = 0; j < nElem; j++) {
        list = &arr[i][0];
      }
      sprintf(str, "binary-%d", i);
      name = &str[0];
      writeBinary(name,list,nElem);
      exit(0);
    }
  }
  for (int i = 0; i < nList; i++) {
    wait(NULL);
  }

}

int main(){

  int nList=5;
  int nElem=5;

  int num[5][5] = {
    {10, 42, 21, 243,  4},
    {5, 641, 8, 7,  78},
    {92, 105, 1,171, 1},
    {24, 5, 31,30, 6},
    {972, 15, 81,10, 801}
  };

  int **numbers;
  numbers=(int**)malloc((nList*nElem)*sizeof(int));
  *numbers = &num[0][0];


  sortAllListsFork(numbers, nList, nElem);

  return 0;
}
