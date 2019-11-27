#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/wait.h>

void child(int *fd, char **cmd){

  dup2(fd[1],1);
  dup2(fd[1],2);
  execvp(cmd[0],cmd);
  printf("ERROR\n");
}
