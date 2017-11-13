//
// This is the solution to CPSC 213 Assignment 5.
// Do not distribute this code or any portion of it to anyone in any way.
// Do not remove this comment.
//

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct Element {
  char   name[200];
  struct Element *next;
};

struct Element *top = 0;

void push (char* aName) {
  struct Element* e = malloc (sizeof (*e));    // Not the bug: sizeof (*e) == sizeof(struct Element)
  strncpy (e->name, aName, sizeof (e->name));  // Not the bug: sizeof (e->name) == 200
  e->next  = top;
  top = e;
}

void pop (char* buf, int bufsiz) {
  struct Element* e = top;
  top = e->next;
  strncpy (buf, e->name, bufsiz);
  free (e);
}

int main (int argc, char** argv) {
  char w[100], x[100], y[100], z[100];
  push ("A");
  push ("B");
  pop (w, sizeof(w));
  push ("C");
  push ("D");
  pop (x, sizeof(x));
  pop (y, sizeof(y));
  pop (z, sizeof(z));
  printf ("%s %s %s %s\n", w, x, y, z);
}
