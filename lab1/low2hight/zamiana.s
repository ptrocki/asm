SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
SYSCALL =0x80

.bss
.equ rozmiar, 11
.lcomm b1, rozmiar

.data
hello: .ascii "Wprowadz znaki do zamiany:\n"
#wyraz: .ascii ""
hello_len = . - hello
.text
.global _start
_start:

#Wyswietlenie komunikatu
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $hello, %ecx
movl $hello_len, %edx #Liczba znakow w zmiennej hello
int $SYSCALL
#Wprowadzenie wyrazu z klawiatury
movl $SYSREAD, %eax
movl $STDIN, %ebx
movl $b1, %ecx
movl $rozmiar, %edx
int $SYSCALL

subl $1, %eax
pushl %eax

call zamien123

popl %eax
addl $1, %eax

#Wyswietlenie wyrazu
movl %eax, %edx
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl $b1, %ecx
int $SYSCALL

#Zakonczenie programu
movl $SYSEXIT, %eax
movl $EXIT_SUCCESS, %ebx
int $SYSCALL

#Zamiana malych liter na duze
.type zamien123, @function
zamien123:
pushl %ebp
movl %esp, %ebp

movl 8(%ebp), %eax #rozmiar bufora

movl $0, %edi
zamien:
cmpl %eax, %edi
je koniec
pushl %eax
movb b1(,%edi,1), %al
xor $0x20, %al
movb %al, b1(,%edi,1)
incl %edi
popl %eax
jmp zamien

koniec:
movl %ebp, %esp
popl %ebp
ret
