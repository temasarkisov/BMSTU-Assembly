#include <stdio.h>
#include <string.h>

#define MAX_LEN 64


extern void asm_copy(char *dst, char *src, int length);



int asm_length(char *src)
{
    int length = 0;

    __asm__
    (
        ".intel_syntax noprefix\n"  // Уходим от синтаксиса AT&T
        "mov EAX, 64000\n"  
        "mov ECX, 64000\n"
        "lea RDI, [%1]\n"  // Косвенная адресация (DS:src)
        "repnz scasb\n"  //  Побайтовое считывание строки

        "sub EAX, ECX\n"  // В AL записалась длина 
        "dec EAX\n"  
        "mov %0, EAX\n"
        : "=r" (length)  // Выходной параметр
        : "r" (src)  // Входной параметр
        : "eax", "ecx", "rdi", "al"  // Разрушаемые регистры

    );

    return length;
}


int main()
{
    char src_length[] = "length testing";

    int length = asm_length(src_length); 
    printf("\n### LENGTH ###\n");
    printf("Used string: '%s'\n", src_length);
    printf("\tLibrary length:    %ld\n", strlen(src_length));
    printf("\tCalculated length: %d\n\n", length);

    char src[] = "Let's test it out!";
    char dst[MAX_LEN] = { 0 };

    asm_copy(dst, src, asm_length(src));
    printf("\n### TEST 1 (trivial testing) ###\n");
    printf("\tSource string: '%s'\n", src);
    printf("\tDest. string:  '%s'\n", dst);

    asm_copy(src, src, 10);
    printf("\n### TEST 2 (dst = src, copy length = 10) ###\n");
    printf("\tString: '%s'\n", src);

    char src_1[] = "Let's test it out!";
    asm_copy(src_1, src_1 + 2, 10);
    printf("\n### TEST 3 (src = dst + 2; copy length = 10) ###\n");
    printf("\tString: '%s'\n", src_1);

    char src_2[] = "Let's test it out!";
    asm_copy(src_2 + 2, src_2, 10);
    printf("\n### TEST 4 (src = dst - 2, copy length = 10) ###\n");
    printf("\tString: '%s'\n", src_2);

    return 0;
}
