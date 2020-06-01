#include <stdio.h>

int main()
{
    int value;

    printf("Enter value: ");
    scanf("%d", &value);

    if (value % 2 == 0)
    {
        printf("Access: GRANTED!\n");
    }
    else
    {
        printf("Access: DENIED!\n");
    }

    return 0;
}
