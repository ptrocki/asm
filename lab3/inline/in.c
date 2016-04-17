#include <stdio.h>

int main(void)
{
int a1 = 10;
int b1 = 5;
int c1 = 0;

__asm__ __volatile__ 
(
	"imull %%ebx, %%eax\n" //mnozenie
	:"=a"(c1)
	:"a"(a1), "b"(b1)
);

printf("wynik: %d\n", c1);

return 0;
}
