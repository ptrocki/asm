.data
napis: .ascii "%s, Dzien urodzenia: %d\n\0"
name: .ascii "Piotr\0"

ciagformatujacy2: .ascii "%d\0"
zmienna: .long 0

.text
.globl main
main:

pushl $zmienna
pushl $ciagformatujacy2
call scanf
addl $8, %esp

pushl zmienna
pushl $name
pushl $napis
call printf
addl $12, %esp
pushl $0

call exit
