#srednio to dziala 

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
EXIT_SUCCESS = 0
SYSCALL32 = 0x80 
STDIN = 0 

#statically-allocated variables
.bss

.equ rozmiar, 255
.lcomm bufor, rozmiar

.lcomm wynik, rozmiar

.equ conv, 0x30
.equ one_arg, 4

.data
sixteen: .long 16

hello: .ascii "Wprowadz liczbe binarna \n"
textLenght = . - hello

errorText: .ascii "Cos poszlo nie tak \n"
errorLength = . - errorText

buforLength: .long 0

wynikHexa: .long 0
wynikHexaLength = . - wynikHexa 

wynikascii: .space 255
wynikasciiLength = . - wynikascii

.text
.global _start
_start:

#Wyswietlenie komunikatu
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $hello, %ecx
movl $textLenght, %edx
int $SYSCALL32 

#Pobranie liczby w ASCII
movl $SYSREAD, %eax
movl $STDIN, %ebx
movl $bufor, %ecx
movl $rozmiar, %edx
int $SYSCALL32

#Usuwamy znak \n
sub $1, %eax
mov %eax, buforLength

#konwersja z ascii na int
pushl %eax #rozmiar bufora
call asciinaint 
addl $one_arg, %esp #czyscimy stos

#konwersja bin na ascii
pushl %eax #rozmiar bufora 
call intTobin

#wypisanie liczb
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $wynikascii, %ecx
movl $wynikasciiLength, %edx
int $SYSCALL32 

movl $SYSEXIT, %eax
movl $EXIT_SUCCESS, %ebx
int $SYSCALL32

#%eax trzymamy dlugosc znakow
.type asciinaint, @function
asciinaint:
pushl %ebp
movl %esp, %ebp
movl 8(%ebp), %eax  #

movl $0, %edi
movl $0,%ebx
zamien:
cmpl %eax, %edi
je koniec
pushl %eax
movb bufor(,%edi,1), %bl #sciagamy pierwszy bajt z bufora ASCII
cmp $'0', %bl
jb error
cmp $'1',%bl
ja error
#teraz wiemy ze miesci sie w zakresie
subb $'0', %bl  #odejmujemy wartosc 0x30 by powstal int
#pobralismy najstarsza pozycje 
movb %bl, bufor(,%edi,1) # wpisujemy do bufora
incl %edi 			  # zwiekszamy wskaznik 
jmp zamien			# znowu zamieniamy

error:
#Wyswietlenie komunikatu o bledzie
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $errorText, %ecx
movl $errorLength, %edx
int $SYSCALL32 

koniec:
popl %ebp
ret

.type intTobin, @function
intTobin:
pushl %ebp
movl %esp, %ebp
movl 8(%ebp), %ebx  

movl $0, %edi #licznik dla bufora intow
movl $0, %esi #licznik dla bufora ascii
movb $0, %dl #licznik dla pentli
movl $0, %eax #zerujemy 
movb $1, %al #potega 

makeNumber:
cmpl %ebx, %edi
je conv2ascii
pushl %ebx #dlugosc bufora
movl $0, %ecx #zerujemy rejestr c
movb bufor(,%edi,1), %cl #sciagamy pierwszy bajt z bufora ASCII
movb %al,%dl #tymczasowo przenosimy nasza potege
mul %cl # MULL ax=al*OP
add %ax,wynikHexa 
movl $0,%eax #czyscimy syf
movb %dl,%al # odzyskujemy naszą potęgę
movb $2,%dl  #ax=al*dl
mul %dl 
inc %edi
popl %ebx
movb $0,%dl
jmp makeNumber

conv2ascii:

movl wynikHexa, %eax

kalesony:
cmp $0, %eax
jle koniec 
movb wynikHexa(,%esi,1),%cl
movb wynikHexa(,%esi,1),%ch
andb $0x0F,%cl
andb $0xF0,%ch 
shr $4,%ch

cmp $9,%cl #integer
ja literka 
addb $0x30,%cl
movb %cl,wynikascii(,%esi,1)
drugaCyfra:
cmp $0x9,%ch
ja literka2
addb $'0',%ch
inc %esi
movb %ch,wynikascii(,%esi,1)
koniecPentli:
inc %esi
subl $0x2C,%eax
jmp kalesony

literka:
addb $0x57,%cl
movb %cl,wynikascii(,%esi,1)
jmp drugaCyfra

literka2:
addb $0x57,%ch
movb %ch,wynikascii(,%esi,1)
jmp koniecPentli

koniec2:

popl %ebp
ret

make
all: funkcja
funkcja: z.s
	as  -g --32 -o lab1.o z.s
	ld -m elf_i386 -o b lab1.o
