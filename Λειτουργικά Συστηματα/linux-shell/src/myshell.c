#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdbool.h>
/*
* init variables
*/
pid_t child_pid, wpid; // will be used for creating child - fork();
int error_before=0; // error handler - flag
int status = 0; // will be used for parent to wait child
int fd[2]; // variables for pipe()
static int gr_error = 0; //flag error for ; letter in shell
static int ad_error = 0; //flag error for && letter in shell
static int bg_error = 0; //flag error for > letter in shell
static int lo_error = 0; //flag error for < letter in shell
static int pi_error = 0; //flag error for | letter in shell
/*
fd[0]; //-> for using read end
fd[1]; //-> for using write end
 */
int MAX_INPUT = 512; //constant for maximum input
/*
  *void promptMessage
  prints shell promptMessage
*/
void promptMessage(){
  while ((wpid = wait(&status)) > 0); //wait all child finish
  printf("mpountouridis_8872>");//then print
}
int count(char **cmd,int pos,int size,int dev_mode){
  int result = 0; //flag for errors
  int lastelem = strlen(cmd[pos])-1; //possition of last item - command
  if(dev_mode ==1){ //case ;
  for (int i = 1; i<size; i++){ //searching for double ;
    if(cmd[pos][i-1] == ';' && cmd[pos][i] == ';'){ //if true
      result=1; //change flag
    } //end
  }//end of if true
  if (cmd[pos][0] == ';' && pos ==0){ //error command
    result = 2; //change flag
  }
  if(result >0){ //if error appears
    gr_error = 1; //change error flag
    if(result ==1) //print correct message
    printf("bash: syntax error unexpected \';;\' \n");
    else // print correct message
    printf("bash: syntax error unexpected \';\' \n");
  }
  if(cmd[pos][0] == ';' && cmd[pos][lastelem] == ';'){
    result = 3; //flag case result
  }
  else if(cmd[pos][0] == ';'){
    result = 5; //flag case result
  }
  else if(cmd[pos][lastelem] == ';') {
    result = 6; //flag case result
  }
  else{
    result = 4; //flag case result
  }
  }
  else if (dev_mode == 2){ //case &&
    if(size>=2){ // i-2 must be > 0
    for (int i = 2; i<size; i++){ //searching for triple &
      if(cmd[pos][i-2] == '&'&&cmd[pos][i-1] == '&' && cmd[pos][i] == '&'){ //condition error
        result=1; //change flag
      }
    }
  }
    if (cmd[pos][0] == '&' && pos ==0){  //error condition
      result = 2; //change flag
    }
    if(result >0){ // if error appears
      ad_error = 1; //change flag error
      //printing correct message
      printf("bash: syntax error near unexpected token \`&&\' \n");
    }
    if(cmd[pos][0] == '&' && cmd[pos][1] == '&' && cmd[pos][lastelem] == '&' && cmd[pos][lastelem-1] == '&'){
      result = 3; //flag case result
    }
    else if(cmd[pos][0] == '&' && cmd[pos][1] == '&'){
      result = 5; //flag case result
    }
    else if(cmd[pos][lastelem] == '&' && cmd[pos][lastelem-1] == '&') {
      result = 6; //flag case result
    }
    else{
      result = 4; //flag case result
    }
  }
  else if(dev_mode == 3){
    if(size>=1){
    for (int i = 1; i<size; i++){ //searching for double ;
      if(cmd[pos][i-1] == '>' && cmd[pos][i] == '>'){ //if true
        result=1; //change flag
        printf("Operation \'>>\' not supported yet\n");
        bg_error = 1;
      } //end
    }//end of for
  }
  if(cmd[pos][0] == '>' && cmd[pos][lastelem] == '>'){
    result = 3; //flag case result
  }
  else if(cmd[pos][0] == '>'){
    result = 5; //flag case result
  }
  else if(cmd[pos][lastelem] == '>') {
    result = 6; //flag case result
  }
  else{
    result = 4; //flag case result
  }
}
else if(dev_mode == 4){
  if(size>=1){
  for (int i = 1; i<size; i++){ //searching for double ;
    if(cmd[pos][i-1] == '<' && cmd[pos][i] == '<'){ //if true
      result=1; //change flag
      printf("Operation \'<<\' not supported yet\n");
      lo_error = 1;
    } //end
  }//end of for
}
if(cmd[pos][0] == '<' && cmd[pos][lastelem] == '<'){
  result = 3; //flag case result
}
else if(cmd[pos][0] == '<'){
  result = 5; //flag case result
}
else if(cmd[pos][lastelem] == '<') {
  result = 6; //flag case result
}
else{
  result = 4; //flag case result
}
}
else if (dev_mode == 5){
  if (cmd[pos][0] == '|' && pos ==0){ //error command
    result = 2; //change flag
  }
  if(result > 0)
  {
    pi_error = 1; //flag pi error
    printf("bash: syntax error near unexpected token \`|\' \n");
  }
  if(cmd[pos][0] == '|' && cmd[pos][lastelem] == '|'){
    result = 3; //flag case result
  }
  else if(cmd[pos][0] == '|'){
    result = 5; //flag case result
  }
  else if(cmd[pos][lastelem] == '|') {
    result = 6; //flag case result
  }
  else{
    result = 4; //flag case result
  }
}
return result;
}
//VOID COMMAND EXECUTION
void command_execution(char *cmd){
  char *temp = malloc(MAX_INPUT*sizeof(int)); //allocating data for command-temp variable
  strcpy(temp, cmd); // coping user command to temp
  // we are going to get all words given by removing all spaces
   const char key[2] = " "; // seting delimeter: space
   char *part; // we will use part to split temp with delimeter: space
   part = strtok(temp,key); //spliting temp for first time
   int counter_key = 0; //counter for splits
   while (part != NULL){ //spliting until no more spaces found
     ++counter_key; //increase counter
     part = strtok(NULL, key); //try to split again
   }// end of spliting
   if(counter_key>0){ //checks if user input is blank
   char *parts[100]; // we will save here all words user writen to: parts array
   char *res[100];
   int pos = 0; // possition counter
   strcpy(temp,cmd); // coping commad to temp
   int start = 0; //possition of starting command
   int end = 0; //possition end of command
   int command_counter = 0; //counter for commands
    //reading command
   for (char *p = strtok(cmd," "); p != NULL; p = strtok(NULL, " ")){
   parts[pos] = p; //saving all words of commands to parts
   pos++; //increase counter
  }
  int array_counter = 0; // size of b: 2d-array
  int array_max = 0;
  // BEFORE EXECUTING COMMANDS
  char *b[100]; //init b
  for (int i = 0; i< pos; i++){ //searching for ; inside parts
    if( (strstr(parts[i],";") != NULL && strcmp(parts[i],";") !=0 ) || strcmp(parts[0],";") == 0 ){ //condition to replace
      int bash_error = count(parts,i,strlen(parts[i]),1); //searching for ; inside parts
      if(gr_error>0){
        break;
      }
    for (char *rr = strtok(parts[i],";"); rr != NULL; rr = strtok(NULL, ";")){ //replacing ;
    if(bash_error == 5 || bash_error == 3){ //exception 1
      b[array_counter] = ";";
      array_counter++;
    }
    b[array_counter] = rr; //saving
    array_counter++;
    if(bash_error == 6 || bash_error == 3 || bash_error == 4){ //exception 2
    b[array_counter] = ";";
    array_counter++;
    }
   }
   if(bash_error == 4){ //exception 3
     array_counter = array_counter -1;
   }
  }
  else{
    b[array_counter] = parts[i]; //saving
    array_counter++;
  }
}
//end of ;
array_max = array_counter;
array_counter = 0;
char *d[100];
for (int i = 0; i< array_max; i++){ //searching for && inside b
  if( (strstr(b[i],"&&") != NULL &&strcmp(b[i],"&&") !=0 ) || strcmp(b[0],"&&") ==0 ){ //condition to replace
    int bash_error = count(b,i,strlen(b[i]),2);  //searching for && inside b
    if(ad_error>0){
      break;
    }
  for (char *rr = strtok(b[i],"&&"); rr != NULL; rr = strtok(NULL, "&&")){ //replacing
    if(bash_error == 5 || bash_error == 3){ //exception 1
      d[array_counter] = "&&";
      array_counter++;
    }
  d[array_counter] = rr; //saving
  array_counter++;
  if(bash_error == 6 || bash_error == 3 || bash_error == 4){ //exception 2
  d[array_counter] = "&&";
  array_counter++;
  }
 }
 if(bash_error == 4){ //exception 3
   array_counter = array_counter -1;
 }
}
else{
  d[array_counter] = b[i]; //saving
  array_counter++;
}
} //end of &&
array_max = array_counter;
array_counter = 0;
char *e[100];
for (int i = 0; i< array_max; i++){ //searching for > inside d
  if(strstr(d[i],">") != NULL && strcmp(d[i],">") !=0 ){ //condition to replace
    int bash_error = count(d,i,strlen(d[i]),3); //searching for > inside d
    if(bg_error>0){
      break;
    }

  for (char *rr = strtok(d[i],">"); rr != NULL; rr = strtok(NULL, ">")){ //replacing
    if(bash_error == 5 || bash_error == 3){ //exception 1
      e[array_counter] = ">";
      array_counter++;
    }
  e[array_counter] = rr; //saving
  array_counter++;
  if(bash_error == 6 || bash_error == 3 || bash_error == 4){ //exception 2
  e[array_counter] = ">";
  array_counter++;
  }
 }
 if(bash_error == 4){ //exception 3
   array_counter = array_counter -1;
 }
}
else{
  e[array_counter] = d[i]; //saving
  array_counter++;
}
}// end of >
array_max = array_counter;
array_counter = 0;
char *f[100];
for (int i = 0; i< array_max; i++){
  if(strstr(e[i],"<") != NULL && strcmp(e[i],"<") !=0 ){
    int bash_error = count(e,i,strlen(e[i]),4);
    if(lo_error>0){
      break;
    }

  for (char *rr = strtok(e[i],"<"); rr != NULL; rr = strtok(NULL, "<")){
  if(bash_error == 5 || bash_error == 3){
    f[array_counter] = "<";
    array_counter++;
  }
  f[array_counter] = rr; //saving
  array_counter++;
  if(bash_error == 6 || bash_error == 3 || bash_error == 4){
  f[array_counter] = "<";
  array_counter++;
  }
 }
 if(bash_error == 4){
   array_counter = array_counter -1;
 }
}
else{
  f[array_counter] = e[i]; //saving
  array_counter++;
}
}//end of <
array_max = array_counter;
array_counter = 0;
char *command_end[100];
for (int i = 0; i< array_max; i++){
  if((strstr(f[i],"|") != NULL && strcmp(f[i],"|") !=0 ) ||  strcmp(f[0],"|") == 0 ){
    int bash_error = count(f,i,strlen(f[i]),5);
    if(pi_error>0){
      break;
    }
  for (char *rr = strtok(f[i],"|"); rr != NULL; rr = strtok(NULL, "|")){
  if(bash_error == 5 || bash_error == 3){
    command_end[array_counter] = "|";
    array_counter++;
  }
  command_end[array_counter] = rr; //saving
  array_counter++;
  if(bash_error == 6 || bash_error == 3 || bash_error == 4){
  command_end[array_counter] = "|";
  array_counter++;
  }
 }
 if(bash_error == 4){
   array_counter = array_counter -1;
 }
}
else{
  command_end[array_counter] = f[i]; //saving
  array_counter++;
}
}
array_max = array_counter;
array_counter = 0;
// cheching flags before execute
if(gr_error ==0 && ad_error == 0 && bg_error == 0 &&  lo_error == 0 &&pi_error == 0){
for(int i = 0;i<array_max; i++){
  if(strcmp(command_end[i],";") == 0){
     end = i; //read command until greek question mark
     char *command_todo[end-start+1]; // creating array to save command
     command_counter = 0; //counter for command
     for (int possition = start; possition < end; possition++){
       command_todo[command_counter] = command_end[possition];
    //   printf("%s\n",command_todo[command_counter]); //saving command
       ++command_counter; //increate counter
     }
     command_todo[command_counter] = 0; //adding zero to last possition of array
     if(error_before == 0){ //checking for errors before &&
     child_pid = fork(); //creating child
     while ((wpid = wait(&status)) > 0); //wait child to finish
     }
     if (child_pid == 0) { //child is here
     if((execvp(command_todo[0],command_todo)<0)){ //executing command
       if(strcmp(command_todo[0],"quit")!=0){
       printf("error\n"); //print error if fails
       }
     }
     exit(0); //bye bye child
     }
     while ((wpid = wait(&status)) > 0); //wait child to finish
     error_before = 0; // refresh error
     start = i + 1; //changing possition of start command
  }
  // GREEK QUESTION MARK END
   //exception &&
   if(strcmp(command_end[i],"&&") == 0){
     end = i; //read command until &&
     char *command_todo_2[end-start+1]; // creating array to save command
     command_counter = 0;  //counter for command
     for (int possition  = start; possition < end; possition++) {
       command_todo_2[command_counter] = command_end[possition]; //saving command
       ++command_counter; //increate counter
     }
     command_todo_2[command_counter] = 0; //last possition of array must be zero
     pipe(fd); //pipe child
     if(error_before==0){
     child_pid = fork(); //creating child
     while ((wpid = wait(&status)) > 0); //wait child to finish
     }
     if (child_pid == 0) { //child goes here
       if(error_before!=0){ //change error value
       error_before = 0;
       }
     if(execvp(command_todo_2[0],command_todo_2)<0){ //execute command
       error_before = 1; // change error flag state
       if(strcmp(command_todo_2[0],"quit")!=0){
       printf("error\n"); // prints error
       }
     }
     close(fd[0]);
     write(fd[1], &error_before, sizeof(error_before)); // pass error flag to parent
     close(fd[1]);
     exit(0);
     }
     else{ //parent goes here
       close(fd[1]);
       read(fd[0], &error_before, sizeof(error_before)); //parent reads
       close(fd[0]);
     }
     while ((wpid = wait(&status)) > 0); //parent waits child to finish
     start = i + 1; //refresh start possition
   }// end of && exception
   //OUTPUT REDIRECTION
      if(i>0){ // avoid outofbounds exception
      if(strcmp(command_end[i-1],">") == 0){
        end = i-1; //refresh end possition
        char *command_todo_3[end-start+1]; //creating char array to save command
        command_counter = 0; //init counter
        for (int possition  = start; possition < end; possition++) {
          command_todo_3[command_counter] = command_end[possition]; //saving command
          ++command_counter; //increase counter
        }
        command_todo_3[command_counter] = 0; //last possition of array must be zero
        child_pid = fork(); //create new child
        while ((wpid = wait(&status)) > 0); //parent waits for his child
        if (child_pid == 0) { //child goes here
          //implementing OUTPUT REDIRECTION
          int fileDescriptor = open(command_end[i], O_CREAT | O_TRUNC | O_WRONLY, 0600);
          dup2(fileDescriptor, STDOUT_FILENO);
          if(execvp(command_todo_3[0],command_todo_3)<0){
            if(strcmp(command_todo_3[0],"quit")!=0){
            }
          }
          close(fileDescriptor);
          exit(0); //bye bye child
        }
        start = i + 1; //refreshing start possition
      }// END OF OUTPUT REDIRECTION
    }//end of outofbounds check
    if(i>1){ //avoid outofbounds error
  //INPUT REDIRECTION
  if (strcmp(command_end[i-1],"<") == 0) {
    end = i-1; //refreshing end possition
    char *command_todo_4[end-start+1]; //creating char array to save command
    command_counter = 0; //init counter
    for (int possition  = start; possition < end; possition++) {
      command_todo_4[command_counter] = command_end[possition]; //saving command
      ++command_counter; //increase counter
    }
    command_todo_4[command_counter] = 0; //last possition of char array must be zero
    child_pid = fork(); //create a new child
    while ((wpid = wait(&status)) > 0); //parent waits for his child
   if (child_pid == 0) { //child goes here
     //implementing INPUT REDIRECTION
     close(0);
     int fd = open(command_end[i],O_RDONLY,0664);
     if(execvp(command_todo_4[0],command_todo_4)<0){
       if(strcmp(command_todo_4[0],"quit")!=0){
         //do nothing
       }
     }
      exit(0); //bye bye child
    }
    start = i + 1; //refreshing start possition
  }//END OF INPUT REDIRECTION
}// end outofbounds check
//command ends
   if(i == array_max-1){ //when command ends
     end = i; //refresh end possition
     char *last_command_todo[end-start+2]; //creating char array to save command
     command_counter= 0; //init counter
     for (int possition = start; possition < array_max; possition++){
       last_command_todo[command_counter] = command_end[possition]; //save command to char array
       ++command_counter; //increase counter
     }
     last_command_todo[command_counter] = 0; //last possition of char array must be zero
if(error_before == 0){ //if there was not error before, fork
     child_pid = fork(); //new child
     while ((wpid = wait(&status)) > 0); //parent waits for child
}
     if (child_pid == 0) { //child goes here
     if(execvp(last_command_todo[0],last_command_todo)<0){ //executing command
     if(strcmp(last_command_todo[0],"quit")!=0){
       printf("error\n");
       }
     }
     exit(0); //bye bye child
     }
     error_before = 0; //refreshing error for next commands
   }
   }
}//pi ad bg error check
}//counter key
gr_error = 0;
lo_error = 0;
ad_error = 0;
bg_error = 0;
pi_error = 0;

} // end of command_execution
int main( int argc, char **argv){
    if(argc == 1){ // argc is set to logic 1 when we dont have any inputs.
  // mode interactive
  char *cmd = malloc(MAX_INPUT*sizeof(int)); //allocating data for command
  char code_exit[] = "quit\0"; // code_exit is a flag to see when user wants to quit
  while (strcmp(cmd,code_exit) != 0) { // if user command is quit interactive mode ends.
  promptMessage(); // prints shell prompt
  fgets(cmd, MAX_INPUT, stdin); //get user input with MAX_INPUT of 256 characters
  if ((strlen(cmd) > 0) && (cmd[strlen (cmd) - 1] == '\n')){  //checking if user input is blank
  cmd[strlen (cmd) - 1] = '\0'; // adding \0 to [strlen (cmd) - 1] possition
  }
  command_execution(cmd); //void implements execution of cmd command
  }
} //end of argc == 1
    if(argc == 2){
      int count_steps = 0;
      int quitfound = 0;
      FILE *f; //init file variable
      char c; //init char variable
      char *temp_ = malloc(256*sizeof(char)); // mem allocation
      char *cmd_ = malloc(256*sizeof(char)); //mem allocation
      f=fopen(argv[1],"rt"); //open given file
        while((c=fgetc(f))!=EOF){
          count_steps++;
        }
          fclose(f);
        f=fopen(argv[1],"rt"); //open given file
        int cc = 0;
        for (int i = 0; i<count_steps; i++){
          c=fgetc(f);
          if(c =='\n'){
            for(int s = cc; s<strlen(cmd_); s++){
              cmd_[s] = '\0'; //remove trash
            }
            if(strcmp(cmd_, "quit")==0){
              quitfound = 1; //flag for quit command
              break;
            }
            command_execution(cmd_); //executing command
            cc=0;
          }
          else{
            cmd_[cc] = c;
            cc++;
          }
        }
        fclose(f);
        if(quitfound==0){
          printf("note: command quit not found\n");
          printf("exit\n");
        }
    }
}
