.data

napis: .ascii "Arg z asemblera, wynik z C: %d\n\0"

.text
.globl main
main: 

push $4
push globalna_z_C
call suma
add $8, %esp
push %eax
push $napis
call printf
addl $8, %esp

pushl $0
call exit
