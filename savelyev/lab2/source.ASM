EOL EQU '$'
ind EQU 2
n1 EQU 500
n2 EQU -50

AStack SEGMENT STACK
DW 12 DUP(?)
AStack ENDS

DATA SEGMENT

mem1 DW 0
mem2 DW 0
mem3 DW 0
vec1 DB 28,27,26,25,21,22,23,24
vec2 DB 20,30,-20,-30,40,50,-40,-50
matr DB -8,-7,3,4,-6,-5,1,2,-4,-3,7,8,-2,-1,5,6
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
    push DS
    sub AX,AX
    push AX
    mov AX,DATA
    mov DS,AX
; Регистровая
    mov ax,n1
    mov cx,ax
    mov bl,EOL
    mov bh,n2
; Прямая
    mov mem2,n2
    mov bx,OFFSET vec1
    mov mem1,ax
; Косвенная
    mov al,[bx]
    ;mov mem3,[bx]
; Базированная
    mov al,[bx]+3
    mov cx,3[bx]
; Индексная
    mov di,ind
    mov al,vec2[di]
    ;mov cx,vec2[di]
; С базированием и индексированием
    mov bx,3
    mov al,matr[bx][di]
    ;mov cx,matr[bx][di]
    ;mov ax,matr[bx*4][di]
; Вар 1
    mov ax, SEG vec2
    mov es, ax
    mov ax, es:[bx]
    mov ax, 0
; Вар 2
    mov es, ax
    push ds
    pop es
    mov cx, es:[bx-1]
    xchg cx,ax
; Вар 3
    mov di,ind
    mov es:[bx+di],ax
; Вар 4
mov bp,sp
; mov ax,matr[bp+bx]
; mov ax,matr[bp+di+si]

    ;push mem1
    ;push mem2
    mov bp,sp
    mov dx,[bp]+2
    ret 2
Main ENDP
CODE ENDS
    END Main
