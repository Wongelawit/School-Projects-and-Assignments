#include <stdio.h>

int s[10];
int* p = s;

void bar(int a1, int a2){
    p[a2] += a1;
}

void foo(){
    int local1 = 1, local2 = 2;
    bar(3,4);
    bar(local1,local2);
}

int main(void){
    foo();
    for (int i = 0; i < 10; ++i)
    printf("%d\n", s[i]);
    return 0;
}
