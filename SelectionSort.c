#include <stdio.h>
//order == 1 && j < size
#define SIZE     5    /* Número de elementos do array */

void SelectionSort(char *array, char size, int order) {

    char i, j, min, aux;
	char startAddr = 0;

//s3
    for (i = startAddr; i + 1 < size; i++) { //era size - 1 mas mudei por ser mais facil no logisim
        min = i;
		
//s4 e Stemp
        for (j = i + 1; j < size; j++) {
			//s6
			aux = array[j] 
            if (order == 1 && aux < array[min] || order == 0 && aux > array[min] ) { // Cresc ou decre
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