.data 
f0: .float 9.0
f1: .float 0.0
s: .byte 2
#output2: .string "%hx"

.global func
.type func,@function
func: 
#movl $0,%eax 
flds f0 #st0=f0
fdiv f1 #st0 f1=f0/f1
FSTSW %ax
finit 

ret
