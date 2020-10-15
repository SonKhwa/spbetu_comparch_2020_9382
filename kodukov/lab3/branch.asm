STACKSG SEGMENT PARA STACK 'Stack'

DW 32 DUP(?)

STACKSG ENDS

DATASG SEGMENT PARA 'Data' ;SEG DATA

VARA DW 1h
VARB DW 1h
VARI DW 1h
VARK DW 1h
VARI1 DW 1h
VARI2 DW 1h
VARRES DW 1h

DATASG ENDS ;ENDS DATA

CODE SEGMENT ;SEG CODE

ASSUME DS:DataSG, CS:Code

Main PROC FAR

mov ax, DATASG ;ds setup
mov ds, ax

f1: ;dw f1(VARA,VARB,VARI)

mov ax,VARA ;ax = *si (a)
mov si,VARB ;si = &b
mov bx,VARI ;bx = i
shl bx,1 ;bx *= 2
cmp ax,si ;cmp ax,*si (a,b)
jg f1_1 ;if a>b

f1_2: ;else (6i-10)

shl bx,1 ;bx *= 2
mov ax,VARI ;ax = i
shl ax,1 ;ax *= 2
add ax,bx ;ax += bx (ax = 6i)
sub ax,10 ;ax -= 10
push ax ;ret ax
jmp f1_end

f1_1: ;then -(4i+3) = (-4i - 3)

shl bx,1 ;bx *= 2
sub ax,ax ;ax = 0
sub ax,bx ;ax = -bx (-4i)
sub ax,3 ;ax -= 3
push ax ;ret ax

f1_end:

mov ax,VARI1
pop VARI1

f2: ;dw f2(VARA,VARB,VARI)

mov ax,VARA ;ax = *si (a)
cmp ax,VARB ;cmp ax,*si (a,b)
jg f2_1 ;if a>b
jmp f2_2

f2_1: ;then 20 - 4i

mov bx,VARI ;bx = i
shl bx,1 ;bx *= 2
shl bx,1 ;bx *= 2
mov ax,bx
sub bx,bx ;bx = 0
sub bx,ax ;bx = -ax (bx = -4i)
add bx,20 ;bx += 20
push bx ;ret bx
jmp f2_end

f2_2: ;else 6(1 - i) = -(6i-6)

sub ax,ax; ax = 0
sub ax,VARI ;ax = -i
add ax,1; ax = 1 - i
shl ax,1 ;ax *= 2
mov bx,ax; bx = 2(1-i)
shl ax,1; ax *= 2
add ax,bx ;ax += 2(1-i)
push ax ;ret ax

f2_end:

pop VARI2

f3: ;dw f3(VARI1,VARI2,VARK)

mov ax,VARK ;ax = *si (k)
cmp ax,0 ;cmp k,0
jl f3_1 ;if k < 0

f3_2: ;else max(7, abs(i2))

mov ax,VARI2 ;ax = i2
cmp ax,0 ;cmp i2,0
jnl f3_2_c ;unless ax >= 0
neg ax ;ax *= -1
f3_2_c: ;else dont
cmp ax,7
jnl f3_2_d ;unless ax >= 7
mov ax,7 ;ax = 7
f3_2_d:
push ax ;ret i2
jmp f3_end

f3_1: ;then abs(i1-i2)

mov ax,VARI1 ;ax = i1
sub ax,VARI2 ;ax -= i2 (ax = i1 - i2)
cmp ax,0 ;cmp (i1 - i2),0
jnl f3_1_c ;unless ax >= 0
neg ax ;neg ax
f3_1_c: ;else dont
push ax ;ret ax

f3_end:

pop VARRES
mov ah, 4ch ;exit
int 21h

Main ENDP
CODE ENDS
END Main