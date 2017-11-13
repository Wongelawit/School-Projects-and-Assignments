#include <stdio.h>

int x[] = {1,2,3,-1,-2,0,184,340057058};
int y[8];

int f(int a1){
	int counter = 0;
	while(a1){
		if (a1&0x80000000)
			counter++;
		a1 = (a1 << 1);
	}
	return counter;
}

int main(void){
	int i = 8;
	while (i){
		i--;
		y[i] = f(x[i]);
	}
    for (int i = 0; i < 8; ++i)
        printf("%d\n", x[i]);

    for (int i = 0; i < 8; ++i)
        printf("%d\n", y[i]);
	return 0;
}
