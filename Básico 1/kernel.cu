// Includes necesarios
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cuda_runtime.h>

#define N 8 // Definimos el tamaño del array (en este caso, 8 elementos)

// Función principal que se ejecuta en el host (CPU)
int main(int argc, char** argv)
{
    // Declaración de punteros para los arrays en memoria del host y device
    float* hst_A, * hst_B; // hst_A y hst_B en el host (CPU)
    float* dev_A, * dev_B; // dev_A y dev_B en el device (GPU)

    // Reserva de memoria en el host para los arrays
    hst_A = (float*)malloc(N * sizeof(float)); // Reserva para hst_A
    hst_B = (float*)malloc(N * sizeof(float)); // Reserva para hst_B

    // Reserva de memoria en el device para los arrays
    cudaMalloc((void**)&dev_A, N * sizeof(float)); // Reserva para dev_A en la GPU
    cudaMalloc((void**)&dev_B, N * sizeof(float)); // Reserva para dev_B en la GPU

    // Inicialización de los datos en el array hst_A con números aleatorios entre 0 y 1
    srand((int)23412345); // Semilla para generar números aleatorios
    for (int i = 0; i < N; i++)
    {
        hst_A[i] = (float)rand() / RAND_MAX;  // Genera números aleatorios entre 0 y 1
    }

    // Mostrar los datos generados en hst_A (entrada)
    printf("ENTRADA (hst_A):\n");
    for (int i = 0; i < N; i++)
    {
        printf("%.2f ", hst_A[i]); // Imprime con 2 decimales
    }
    printf("\n");

    // Transferencia de datos desde el host (hst_A) al device (dev_A)
    cudaMemcpy(dev_A, hst_A, N * sizeof(float), cudaMemcpyHostToDevice);

    // Copia de datos dentro del device: de dev_A a dev_B
    cudaMemcpy(dev_B, dev_A, N * sizeof(float), cudaMemcpyDeviceToDevice);

    // Transferencia de datos desde el device (dev_B) al host (hst_B)
    cudaMemcpy(hst_B, dev_B, N * sizeof(float), cudaMemcpyDeviceToHost);

    // Mostrar los datos copiados en hst_B (salida)
    printf("SALIDA (hst_B):\n");
    for (int i = 0; i < N; i++)
    {
        printf("%.2f ", hst_B[i]); // Imprime con 2 decimales
    }
    printf("\n");

    // Liberación de memoria en el host y en el device para evitar problemas de fuga de memoria.
    free(hst_A); // Liberamos la memoria reservada para hst_A en el host
    free(hst_B); // Liberamos la memoria reservada para hst_B en el host
    cudaFree(dev_A); // Liberamos la memoria reservada para dev_A en el device
    cudaFree(dev_B); // Liberamos la memoria reservada para dev_B en el device

    // Mostrar la fecha y hora de ejecución del programa
    time_t fecha;
    time(&fecha);
    printf("***************************************************\n");
    printf("Programa ejecutado el: %s", ctime(&fecha)); // Muestra la fecha y hora actual
    printf("<pulsa [INTRO] para finalizar>");
    getchar(); // Pausa antes de finalizar

    return 0;
}
