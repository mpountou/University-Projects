/**
 * @file   utilities.c
 * @author fcdimitr <fcdimitr@auth.gr>
 * @date   Wed Oct 11 15:55:33 2017
 * 
 * @brief  Source code implementation for utilities functions
 * 
 * 
 */

#include "utilities.h"

char *updateFilename( char *filename ){

  char tmp1[20], tmp2[20];
  int season, episode;

  char *result = (char *)malloc(7*sizeof(char));
  
  sscanf( filename, "%s %d %s %d", tmp1, &season, tmp2, &episode );
  
  sprintf( result, "S%02d_E%02d", season, episode );

  return result;
  
}
