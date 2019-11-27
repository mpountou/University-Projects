#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void updateArraySize(int **x, int n, int nNew){
  if(nNew<n){
    memcpy(*x, *x+n-nNew, nNew*sizeof(int));
    *x= (int*)realloc(*x, nNew*sizeof(int));
  }else if(nNew>n){
    *x= (int*)realloc(*x, nNew*sizeof(int));
    for (int i = 0; i < nNew-n; i++) {
      x[0][i+n]=x[0][n-1];
    }
  }
}



int main()
{
  int n=10;
  int nNew=13;

  int *arr = (int*)malloc(n*sizeof(int));
  for (int i = 0; i < n; i++) {
    arr[i]=i;
  }
  int *y = arr;
  int **x = &y;

  printf("before \n");

  for (int i = 0; i < n; i++) {
    printf("%d %d \n",x[0][i], &x[0][i] );
  }
  printf("\n");


  updateArraySize(x,n,nNew);


  printf("\n");
  printf("after \n");
  if(nNew<=n){
    for (int i = 0; i < n; i++) {
      printf("%d %d \n", x[0][i], &x[0][i] );
    }
  }else{
    for (int i = 0; i < nNew; i++) {
      printf("%d %d \n", x[0][i], &x[0][i] );
    }
  }
  return 0;
}
