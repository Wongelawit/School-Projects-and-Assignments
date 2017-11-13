#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct Element {
    char   name[200];
    struct Element *next;
};

struct Element *top = 0;

char w[200], x[200], y[200], z[200];

void push (char* aName) {
    struct Element* e = malloc (sizeof (*e));    // Not the bug: sizeof (*e) == sizeof(struct Element)
    strncpy (e->name, aName, sizeof (e->name));  // Not the bug: sizeof (e->name) == 200
    e->next  = top;
    top = e;
}

void pop (char* c) {
    struct Element* e = top;
    top = e->next;
    strncpy (c, e->name, 200);
    free (e);
}

int main (int argc, char** argv) {
    push ("A");
    push ("B");
    pop (w);
    push ("C");
    push ("D");
    pop (x);
    pop (y);
    pop (z);
    printf ("%s %s %s %s\n", w, x, y, z);
}
