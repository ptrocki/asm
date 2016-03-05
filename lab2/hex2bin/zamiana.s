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

.equ rozmiar, 255
.lcomm bufor, rozmiar

.lcomm wynik, rozmiar

.equ conv, 0x30
.equ one_arg, 4

.data
hello: .ascii "Wprowadz liczbe hexadecymalna \n"
textLenght = . - hello

errorText: .ascii "Cos poszlo nie tak \n"
errorLength = . - errorText

buforLength: .long 0

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
zamien:
cmpl %eax, %edi
je koniec
pushl %eax
movb bufor(,%edi,1), %al #sciagamy pierwszy bajt z bufora ASCII
cmp $'0', %al
jb error
cmp $'9',%al
ja nieliczba
#teraz wiemy ze jest to liczba
subb $'0', %al  #odejmujemy wartosc 0x30 by powstal int 
movb %al, wynik(,%edi,1) # wpisujemy do bufora
incl %edi 			  # zwiekszamy wskaznik 
popl %eax			#pobieramy ze stosu rozmiar 
jmp zamien			# znowu zamieniamy

nieliczba:
cmp $'a',%al
jb error
cmp $'f',%al
ja error
subb $0x57,%al
movb %al, wynik(,%edi,1) # wpisujemy do bufora
incl %edi 			  # zwiekszamy wskaznik 
popl %eax			#pobieramy ze stosu rozmiar 
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
movl 8(%ebp), %eax  

movl $0, %edi #licznik dla bufora intow
movl $0, %esi #licznik dla bufora ascii
movb $0, %dl #licznik dla pentli

wyswietl:
cmpl %eax, %edi
je koniec2
pushl %eax #dlugosc bufora
movl $0, %ecx #zerujemy rejestr c
movb wynik(,%edi,1), %cl #sciagamy pierwszy bajt z bufora ASCII
shl $4,%cl #z postaci 0000 1111 robimy 1111 0000

movb $0,%dl

petla:
rclb %cl
jc wstawJeden
movb $'0', wynikascii(,%esi,1)
incl %esi
inc %dl
cmp $4, %dl
je get_next_value
jmp petla

wstawJeden:
movb $'1', wynikascii(,%esi,1)
incl %esi
inc  %dl
cmp $4, %dl
je get_next_value
jmp petla

get_next_value:
inc %edi
popl %eax
jmp wyswietl


koniec2:
popl %ebp
ret

make //
all: funkcja
funkcja: zamiana.s
	as  -g --32 -o lab1.o zamiana.s
	ld -m elf_i386 -o lab1 lab1.o
