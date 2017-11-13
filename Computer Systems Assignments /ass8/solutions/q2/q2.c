//
// This is the solution to CPSC 213 Assignment 8.
// Do not share this code or any portion of it with anyone in any way.
// Do not remove this comment.
//

#include <stdlib.h>
#include <stdio.h>

int q2 (int f, int i, int j) {
  int r;
  switch (f) {
    case 10:
      r = i + j;
      break;
    case 12:
      r = i - j;
      break;
    case 14:
      if (i>j)
	r = 1;
      else
	r = 0;
      break;
    case 16:
      if (i<j)
	r = 1;
      else 
	r = 0;
      break;
    case 18:
      if (i==j)
	r = 1;
      else 
	r = 0;
      break;
    default:
      r = 0;
  }
  return r;
}

int main (int argc, char** argv) {
  if (argc != 4) {
    fprintf (stderr, "usage: q2 f i j\n");
    return EXIT_FAILURE;
  }
  int f = atoi (argv [1]);
  int i = atoi (argv [2]);
  int j = atoi (argv [3]);
  printf ("%d\n", q2 (f, i, j));
}
