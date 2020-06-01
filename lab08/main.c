#include <stdio.h>

int sum(int valueA, int valueB)
{
    int result;

    __asm__
    (
        ".intel_syntax noprefix\n"
        
        "movd MM0, %1\n"
        "movd MM1, %2\n"	

	    "paddb MM1, MM0\n"
	    "movd %0, MM1\n"

        : "=r" (result)
        : "r" (valueA), "r" (valueB)
        : "mm0", "mm1"
    );

    return result;
}

int main()
{
    int valueA = 0;
    int valueB = 0;
    int result = 0;

    printf("SUM OPERATION\n");
    printf("First value: ");
    scanf("%d", &valueA);
    printf("Second value: ");
    scanf("%d", &valueB);

    result = sum(valueA, valueB);
    printf("Result: %d\n", result);

    return 0;
}
