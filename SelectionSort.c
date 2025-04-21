#include <stdio.h>

#define SIZE     5    /* Número de elementos do array */

void SelectionSort(char *array, char size, int order) {

    char i, j, min; //aux;
//s3
    for (i = 0; i < size - 1; i++) {
        min = i;
		
//s4
        for (j = i + 1; j < size; j++) {
			//s6
            if (order == 1) {
                if (array[j] < array[min])  // Crescente
                    min = j;
            }
			//s5
            if (order == 0) {
                if (array[j] > array[min])  // Decrescente
                    min = j;
            }
        }

        if (i != min) {
            array[i] = array[i] ^ array[min];
			
            array[min] = array[i] ^ array[min];
			
            array[i] = array[i] ^ array[min];
        }
    }
}

int main() {
    char array[SIZE] = { 5, 3, -1, 4, 3 };
    int i;
    int order;

    printf("Escolha a direção (0 = decrescente, 1 = crescente): ");
    scanf("%d", &order);

    printf("Array original: ");
    for (i = 0; i < SIZE; i++)
        printf("%d ", array[i]);
    printf("\n");

    SelectionSort(array, SIZE, order);

    printf("Array ordenado: ");
    for (i = 0; i < SIZE; i++)
        printf("%d ", array[i]);
    printf("\n");

    return 0;
}