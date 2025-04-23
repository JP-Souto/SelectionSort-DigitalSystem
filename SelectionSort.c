#include <stdio.h>
#define SIZE 5 /* Número de elementos do array */

void SelectionSort(char *array, char size, int order) {

    char i, j, min, aux;
	char startAddr = 0;

    for (i = startAddr; i + 1 < size; i++) {
        min = i;

        for (j = i + 1; j < size; j++) {
			aux = array[j]; 
			
            if (order == 1 && aux < array[min] || order == 0 && aux > array[min] ) { // Cresce ou decresce
                    min = j;
            }
        }

         if (i != min) {
			 aux = array[i];
			 aux = aux ^ array[min];
			 array[min] = aux ^ array[min];
			 aux = aux ^ array[min];
			 array[i] = aux;
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