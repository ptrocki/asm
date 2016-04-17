.globl globalna_z_asm

.data
.type globalna_z_asm, @object
.size globalna_z_asm, 4
globalna_z_asm: .long 75

.text
.globl funkcja_asm
.type funkcja_asm, @function
funkcja_asm:
pushl %ebp
movl %esp, %ebp

movl 8(%ebp), %eax
movl 12(%ebp), %ebx
mull %ebx
movl %eax, globalna_z_asm

movl %ebp, %esp
popl %ebp
ret
