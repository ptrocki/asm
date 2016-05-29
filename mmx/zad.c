#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "SDL.h"
#include "SDL_image.h"

struct BitMap
{
char Type[2];
unsigned int Size;
short Reserve1;
short Reserve2;
unsigned int OffBits;
unsigned int biSize;
unsigned int biWidth;
unsigned int biHeight;
short biPlanes;
short biBitCount;
unsigned int biCompression;
unsigned int biSizeImage;
unsigned int biXPelsPerMeter;
unsigned int biYPelsPerMeter;
unsigned int biClrUsed;
unsigned int biClrImportant;
} Header;

void obruc(char *imageData, int biWidth, int biHeight, int biBitCount);
int main(void){
//void * memset ( void * ptr, int value, size_t num );
FILE *BMPFile = fopen ("2.bmp", "rb");

memset(&Header, 0, sizeof(Header));

//size_t fread ( void * ptr, size_t size, size_t count, FILE * stream );
fread(&Header.Type, 2, 1, BMPFile); 
fread(&Header.Size, 4, 1, BMPFile); 
fread(&Header.Reserve1, 2, 1, BMPFile); 
fread(&Header.Reserve2, 2, 1, BMPFile); 
fread(&Header.OffBits, 4, 1, BMPFile); 
fread(&Header.biSize, 4, 1, BMPFile);

fread(&Header.biWidth, 4, 1, BMPFile); 
fread(&Header.biHeight, 4, 1, BMPFile); 
fread(&Header.biPlanes, 2, 1, BMPFile); 
fread(&Header.biBitCount, 2, 1, BMPFile); 

fread(&Header.biCompression, 4, 1, BMPFile);
fread(&Header.biSizeImage, 4, 1, BMPFile); 

fread(&Header.biXPelsPerMeter, 4, 1, BMPFile); 
fread(&Header.biYPelsPerMeter, 4, 1, BMPFile); 
fread(&Header.biClrUsed, 4, 1, BMPFile); 
fread(&Header.biClrImportant, 4, 1, BMPFile);

int HEADER_SIZE = Header.biSize; 
int SIZE = Header.biBitCount; 
int IMAGE_SIZE = Header.biSizeImage; 

printf("\nTyp: %s\n", Header.Type); 
printf("Rozmiar: %u\n", Header.Size); 
printf("Zarezerwowane 1: %hd\n", Header.Reserve1);	
printf("Zarezerwowane 2: %hd\n", Header.Reserve2); 
printf("Offset : %u\n", Header.OffBits); 
printf("Wielkosc naglowka informacyjnego: %u\n", Header.biSize); 
printf("Szerokosc w pixelach: %u\n", Header.biWidth);
printf("Wysokosc w pixelach: %u\n", Header.biHeight);
printf("Ilosc wartstw: %hd\n", Header.biPlanes);
printf("Ilosc bitow na piksel: %hd\n", Header.biBitCount); 
printf("Rodzaj kompresji: %u\n", Header.biCompression); 
printf("Rozmiar bitmapy: %u\n", Header.biSizeImage); 
printf("Rozdzielczosc pozioma: %u\n", Header.biXPelsPerMeter); 
printf("Rozdzielczosc pionowa: %u\n", Header.biYPelsPerMeter); 
printf("Kolorow w palecie: %u\n", Header.biClrUsed); 
printf("Waznych kolorow: %u\n\n", Header.biClrImportant);
printf("\n\n");

fseek(BMPFile,0,0);

char *header = (char*) calloc (14+HEADER_SIZE, 1) ;

int headerLength = fread (header, 1, 14+HEADER_SIZE,BMPFile) ; 
fseek(BMPFile, 14+HEADER_SIZE, 0);
char *imageData = (char*) calloc (IMAGE_SIZE, 1) ;
int nread = fread (imageData, 1, IMAGE_SIZE,BMPFile) ; 
printf ("Przeczytano %d bajtow bitmapy.\n", nread) ;
printf ("Przeczytano %d bajtow naglowka.\n", headerLength) ;

obruc(imageData, Header.biWidth, Header.biHeight,Header.biBitCount);
return 0;
}
