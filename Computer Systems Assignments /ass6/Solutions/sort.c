#include <stdio.h>

int a[10] = (int[10]) {6,3,8,3,1,7,4,2,10,5};

void sort (int* a, int n) {
  for (int i=n-1; i>0; i--)
    for (int j=1; j<=i; j++)
      if (a[j-1] > a[j]) {
        int t  = a[j];
        a[j]   = a[j-1];
        a[j-1] = t;
      }
}

int main() {
  sort(a,10);
  for (int i=0; i<10; i++)
    printf ("%d\n",a[i]);
}
