/**
 * @file   episode_rename.c
 * @author fcdimitr <fcdimitr@auth.gr>
 * @date   Wed Oct 11 15:53:58 2017
 * 
 * @brief Contains main function to rename an episode and output
 *        command for mv 
 * 
 */

#include "utilities.h"

/** 
 * Main: entry point
 * 
 * @param argc Number of command line arguments
 * @param argv Array with command line arguments
 */
void main(int argc, char *argv[]){

  if (argc != 2){
    /* Number of inputs should be 2; otherwise aborts */
    fprintf(stderr, "Wrong number of inputs! Aborting...\n");
    exit(EXIT_FAILURE);
  }

  char *filename = argv[1];     /* argv[0] is the executable name */

  fprintf(stdout, "\"%s\"", filename);

  fprintf(stdout, " ");
  
  char *new_filename = updateFilename( filename );
  
  fprintf(stdout, "%s\n", new_filename);

  free( new_filename );

  return;
}
