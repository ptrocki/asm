.data
w:
.int 10000 #Liczba potrzebna do rozjaśnienia i przyciemnienia
.text
.global _negatyw
.type _negatyw, @function
_negatyw:
mov 4(%esp), %esi #bufor
mov 8(%esp), %ecx #rozmiar
mov %esi, %eax
kopiuj:
movq 0(%esi), %mm0
pcmpeqw %mm4, %mm4
pxor %mm4, %mm0 #Tworzenie negatywu
movq %mm0, 0(%esi)
addl $8, %esi
loop kopiuj
mov %ebx, %ecx
ret

.global rozjasnij
.type rozjasnij, @function
rozjasnij:
mov 4(%esp), %esi
#bufor
mov 8(%esp), %ecx #rozmiar
mov %esi, %eax
kopiuj4:
movq 0(%esi), %mm0
pcmpeqw %mm4, %mm4 #same 0 gdy fałsz, 1 gdy prawda. Sprawdzanie równości
paddusb w, %mm0 #dodanie liczby, rozjaśnienie
movq %mm0, 0(%esi)
addl $8, %esi
loop kopiuj4
mov %ebx, %ecx
ret

.global _negatywb
.type _negatywb @function
_negatywb:
mov 4(%esp), %esi #bufor
mov 8(%esp), %ecx #rozmiar
mov %esi, %eax
dzialanie:
xor $0b11111111111111111111111111111111, 0(%esi)
addl $4, %esi
loop dzialanie
ret

.global przyciemnij
.type przyciemnij, @function
przyciemnij:
mov 4(%esp), %esi #bufor
mov 8(%esp), %ecx #rozmiar
mov %esi, %eax
kopiuj6:
movq 0(%esi), %mm0
pcmpeqw %mm4, %mm4 #same 0 gdy fałsz, 1 gdy prawda. Sprawdzanie równości
psubusb w, %mm0 #dodanie liczby, przyciemnienie
movq %mm0, 0(%esi)
addl $8, %esi
loop kopiuj6
mov %ebx, %ecx
ret

.global obroc
.type obroc @function
#Funkcja ta wczytuje na stos poszczególne piksele i wyświetla je na odwrót co za tym idzie, obrazek
#będzie obrócony o 180 stopni.
obroc:
pushl %ebp
movl %esp, %ebp
mov 8(%esp), %esi
#bufor
mov 12(%esp), %ecx #rozmiar
mov %esi, %eax
mov %ecx, %ebx
czytaj:
movl 0(%esi), %edx
pushl %edx
addl $3, %esi
loop czytaj
mov %ebx, %ecx
mov %eax, %esi
wklej:
popl %edx
movl %edx, 0(%esi)
addl $3, %esi
loop wklej
pop %ebp
ret
