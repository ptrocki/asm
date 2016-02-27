#cezar

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
EXIT_SUCCESS = 0
SYSCALL32 = 0x80 
STDIN = 0 

#statically-allocated variables
.bss

.equ rozmiar, 11
.lcomm b1, rozmiar
.equ r2, 2
.lcomm klucz, r2
.equ conv, 0x30
.equ two_arg, 8

.data
hello: .ascii "Wprowadz slowo oraz liczbe przesuniecia \n"
textLenght = . - hello
#wyraz: .ascii ""
.text
.global _start
_start:
#Wyswietlenie komunikatu
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $hello, %ecx
movl $textLenght, %edx
int $SYSCALL32 

#Wprowadzenie wyrazu z klawiatury
movl $SYSREAD, %eax
movl $STDIN, %ebx
movl $b1, %ecx
movl $rozmiar, %edx
int $SYSCALL32

pushl %eax # wrzucenie na stos liczby znakow

movl $SYSREAD, %eax
movl $STDIN, %ebx
movl $klucz, %ecx
movl $r2, %edx
int $SYSCALL32

movl $0, %ebx
movl $0, %edi
movb klucz(,%edi), %bl #sciagamy jedna cyfre
subb $conv, %bl        #trzymamy liczbe przesuniecia


popl %eax
sub $1, %eax

#Wywolanie szyfrowania
pushl %eax #rozmiar bufora
pushl %ebx #klucz
call cezar 
addl $two_arg, %esp #czyscimy stos

movl $rozmiar, %edx
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $b1, %ecx
int $SYSCALL32

movl $SYSEXIT, %eax
movl $EXIT_SUCCESS, %ebx
int $SYSCALL32

.type cezar, @function
cezar:
pushl %ebp
movl %esp, %ebp

movl 12(%ebp), %eax #rozmiar bufora
movl 8(%ebp), %ecx  #klucz

movl $0, %edi

zamien:

cmpl %eax, %edi
je koniec

pushl %eax       #przechowaj rozmiar bufora
movb b1(,%edi,1), %al #sciagamy pierwszy bajt z bufora
movb %al, %cl
subb $0x60, %cl #wyluskaj nr litery np a = 61 -60 = 1 dla b=2 itd.
addb %bl, %cl   #dodajemy liczbe pesuniecia
cmpb $26, %cl   #jesli cl jest wieksze od liczby znakow w alfabecie

addb %bl, %al # nasza liczbe przesuwamy o podany wyzej klucz
movb %al, b1(,%edi,1) # wpisujemy do bufora
incl %edi 			  # zwiekszamy wskaznik 
popl %eax			#pobieramy ze stosu rozmiar klucza
jmp zamien			# znowu zamieniamy

koniec:
movl %ebp, %esp
popl %ebp
ret


makefile
all: funkcja
funkcja: zamiana.s
	as  -g --32 -o lab1.o zamiana.s
	ld -m elf_i386 -o lab1 lab1.o
