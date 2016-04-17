#include <stdio.h>
extern void funkcja_asm();
extern int globalna_z_asm;

int main(void)
{
	funkcja_asm(3,7);
	printf("Zmienna z asemblera: %d\n", globalna_z_asm);
	return 0;
}
