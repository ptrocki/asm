#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void rotate( char* buff,int size, int w, int h );
extern char *_negatyw(char *bitmap, unsigned int rozmiar)
__asm__("_negatyw");
extern char *rozjasnij(char *bitmap, unsigned int rozmiar)
__asm__("rozjasnij");
extern char *_negatywb(char *bitmap, unsigned int rozmiar)
__asm__("_negatywb");
extern char *obroc(char *bitmap, unsigned int rozmiar)
__asm__("obroc");
extern char *przyciemnij(char *bitmap, unsigned int  rozmiar)
__asm__("przyciemnij");
struct BitMap
{
//Stworzenie zmiennych opisujących daną bitmapę
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

int main( )
{
FILE *BMPFile = fopen ("2.bmp", "rb");
memset(&Header, 0, sizeof(Header));

fread(&Header.Type, 2, 1, BMPFile);
fread(&Header.Size, 4, 1, BMPFile);
fread(&Header.Reserve1, 2, 1, BMPFile);
fread(&Header.Reserve2, 2, 1, BMPFile);
fread(&Header.OffBits, 4, 1, BMPFile);
fread(&Header.biSize, 4, 1, BMPFile);
int HEADER_SIZE = Header.biSize;
fread(&Header.biWidth, 4, 1, BMPFile);
fread(&Header.biHeight, 4, 1, BMPFile);
fread(&Header.biPlanes, 2, 1, BMPFile);
fread(&Header.biBitCount, 2, 1, BMPFile);
int SIZE = Header.biBitCount;
fread(&Header.biCompression, 4, 1, BMPFile);
fread(&Header.biSizeImage, 4, 1, BMPFile);
int IMAGE_SIZE = Header.biSizeImage;
fread(&Header.biXPelsPerMeter, 4, 1, BMPFile);
fread(&Header.biYPelsPerMeter, 4, 1, BMPFile);
fread(&Header.biClrUsed, 4, 1, BMPFile);
fread(&Header.biClrImportant, 4, 1, BMPFile);

printf("\nTyp: %s\n", Header.Type);
printf("Rozmiar: %u\n", Header.Size);
printf("Zarezerwowane 1: %hd\n", Header.Reserve1);
printf("Zarezerwowane 2: %hd\n", Header.Reserve2);
printf("Offset tablicy pikseli: %u\n", Header.OffBits);
printf("Rozmiar naglowka DIB: %u\n", Header.biSize);
printf("Szerokosc: %u\n", Header.biWidth);
printf("Dlugosc: %u\n", Header.biHeight);
printf("Wartstw: %hd\n", Header.biPlanes);
printf("Bitow na piksel: %hd\n", Header.biBitCount);
printf("Kompresja: %u\n", Header.biCompression);
printf("Rozmiar bitmapy: %u\n", Header.biSizeImage);
printf("Rozdzielczosc pozioma: %u\n", Header.biXPelsPerMeter);
printf("Rozdzielczosc pionowa: %u\n", Header.biYPelsPerMeter);
printf("Kolorow w palecie: %u\n", Header.biClrUsed);
printf("Waznych kolorow: %u\n\n", Header.biClrImportant);
printf("\n\n");
fseek(BMPFile,0,0);
char *header ;
header = (char*) calloc (14+HEADER_SIZE, 1) ;
int nread2 = fread (header, 1, 14+HEADER_SIZE,BMPFile) ;
printf ("Przeczytano %d bajtow naglowka.\n", nread2) ;
fseek(BMPFile, 14+HEADER_SIZE, 0);
char *data ;
data = (char*) calloc (IMAGE_SIZE, 1) ;
int nread = fread (data, 1, IMAGE_SIZE,BMPFile) ;
printf ("Przeczytano %d bajtow bitmapy.\n", nread) ;
printf("\nWybierz operacje do wykonania:");
printf("\n1. Rozjasnienie");
printf("\n2. Przyciemnienie");
printf("\n3. Negatyw (odwrocenie kolorow)");
printf("\n4. Negatyw bez mmx");
printf("\n5. Obrocenie do gory nogami");
printf("\n\nWybor: ");

int wybor;
scanf("%d",&wybor);
if (wybor==3)
{
FILE *f = fopen ("negatyw.bmp", "wb");
char *data2;
data2 = _negatyw(data,IMAGE_SIZE/8);
fwrite(header,1,nread2,f);
fseek(f,14+HEADER_SIZE,0);
fwrite(data2,1,nread,f);
fclose(f);
}

if (wybor==1)
{
FILE *f2 = fopen ("rozjasnienie.bmp","wb");
char *data3;
data3 = rozjasnij(data,IMAGE_SIZE/8); //Użycie funkcji w Assemblerze
fwrite(header,1,nread2,f2);
fseek(f2,14+HEADER_SIZE,0);
fwrite(data3,1,nread,f2); //Zapis do nowego pliku
fclose(f2);
}

if (wybor==4)
{
FILE *f5 = fopen ("negatywbezmmx.bmp","wb");
char *data5;
data5 = _negatywb(data,IMAGE_SIZE/4);
fwrite(header,1,nread2,f5);
fseek(f5,14+HEADER_SIZE,0);
fwrite(data5,1,nread,f5);
fclose(f5);
}

if (wybor==5)
{
FILE *f6 = fopen ("obroc.bmp","wb");
char *data6;
data6 = obroc(data,IMAGE_SIZE/3);
fwrite(header,1,nread2,f6);
fseek(f6,14+HEADER_SIZE,0);
fwrite(data6,1,nread,f6);
fclose(f6);
}

if (wybor==2)
{
FILE *f8 = fopen ("przyc.bmp","wb");
char *data8;
data8 = przyciemnij(data,IMAGE_SIZE/8);
fwrite(header,1,nread2,f8);
fseek(f8,14+HEADER_SIZE,0);
fwrite(data8,1,nread,f8);
fclose(f8);
}

fclose(BMPFile);
return 0;
}
