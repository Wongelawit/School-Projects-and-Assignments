//
// This is the solution to CPSC 213 Assignment 8.
// Do not share this code or any portion of it with anyone in any way.
// Do not remove this comment.
//

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "list.h"

void printString (element_t sv) {
  char* s = sv;
  printf ("%s\n", s? s : "NULL");
}

void printInt (element_t iv) {
  intptr_t i = (intptr_t) iv;
  printf ("%ld\n", i);
}

void nullIfNegative (element_t* rpv, element_t sv, element_t iv) {
  char** rp  = (char**) rpv;
  char*  s   = sv;
  intptr_t i = (intptr_t) iv;
  *rp = i<0? s : 0;
}

int isNotNegative (element_t iv) {
  intptr_t i = (intptr_t) iv;
  return i >= 0;
}

int isNotNull (element_t s) {
  return s != NULL;
}

void truncate (element_t* rpv, element_t sv, element_t iv) {
  char** rp  = (char**) rpv;
  char*  s   = sv;
  intptr_t i = (intptr_t) iv;
  *rp        = strdup (s);
  if (strlen (*rp) > i)
    (*rp) [i] = 0;
}

void intValue (element_t* rpv, element_t av) {
  intptr_t* rp = (intptr_t*) rpv;
  char*     a  = av;
  char* ep;
  *rp = strtol (a, &ep, 0);
  if (*ep)
    *rp = -1;
}

void max (element_t* rpv, element_t av, element_t bv) {
  intptr_t* rp = (intptr_t*) rpv;
  intptr_t  a  = (intptr_t)  av;
  intptr_t  b  = (intptr_t)  bv;
  *rp = (a>b)? a : b;
}

int main (int argc, char** argv) {

  struct list* l0 = list_create();
  for (int i=1; i<argc; i++)
    list_append (l0, argv [i]);
  
  struct list* l1 = list_create();
  list_map1 (intValue, l1, l0);
  
  struct list* l2 = list_create();
  list_map2 (nullIfNegative, l2, l0, l1);
  
  struct list* l3 = list_create();
  list_filter (isNotNegative, l3, l1);
  
  struct list* l4 = list_create();
  list_filter (isNotNull, l4, l2);

  struct list* l5 = list_create();
  list_map2 (truncate, l5, l4, l3);
  
  list_foreach (printString, l5);
  list_foreach (free, l5);
  
  intptr_t v = -1;
  list_foldl (max, (element_t*) &v, l3);
  printf ("%ld\n", v);
  
  list_destroy (l0);
  list_destroy (l1);
  list_destroy (l2);
  list_destroy (l3);
  list_destroy (l4);
  list_destroy (l5);
}
