STACKSG SEGMENT  PARA STACK 'Stack'
        DW       32 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'				;SEG DATA
VARA	DW	1h
VARB	DW	1h
VARI	DW	1h
VARK	DW	1h
VARI1	DW	1h
VARI2	DW	1h
VARRES	DW	1h
DATASG	ENDS								;ENDS DATA

CODE      SEGMENT   						;SEG CODE
ASSUME  DS:DataSG, CS:Code
	
Main      PROC  FAR
   	mov  ax, DATASG
   	mov  ds, ax
   
	jmp f1
f1_end:
	mov ax,VARI1
	pop VARI1
	
	jmp f2
f2_end:
	pop VARI2
	
	jmp f3
f3_end:
	pop VARRES
	
	mov  ah, 4ch		;завершаем программу
	int  21h  
   
  
f1: 
   mov ax,VARA          ;переменная a в ax
   mov si,VARB          ;переменная b в si
   mov bx,VARI			;переменная i в bx
   shl bx,1				;умножаем переменную i в bx на 2
   
   cmp	ax,si			;сравниваем переменные a и b соответственно
   
   jg	f1_1			;если a>b переходим к метке f1_1

f1_2:					;если a<=b ,то считаем 3*(i+2)
	mov ax,VARI			;ax = i
	add ax,bx			;ax = ax + bx = i + 2*i = 3i
	add ax,6			;ax +=6, ax = 3i+6
	push ax				;ret ax
	jmp f1_c
	
f1_1:   				; если a>b, то считаем -(6*i-4) = -6*i + 4
	shl bx, 1			;bx *= 2 , bx = 4*i
	shl bx, 1           ;bx *= 2,  bx = 8*i
	mov ax,VARI         ;ax = i
	shl ax,1            ;ax = 2*i
	sub ax,bx           ;ax = ax - bx = 2*i - 8*i = -6*i
	add ax,4            ;ax = -6*i + 4
	push ax				;ret ax
	jmp f1_c
	
f1_c:
	jmp f1_end
	
	
f2: 
   mov ax,VARA          ;переменная a в ax
   cmp	ax,VARB			;сравниваем переменные a и b соответственно
   jg	f2_1			;если a>b переходим к метке f2_1

f2_2:					; если a<=b, то считаем 5 - 3*(i+1) = 2 - 3*i
	mov ax,VARI			;ax = i
	shl ax, 1			;ax *= 2 = 2*i
	shl ax, 1           ;ax *= 2 = 4*i
	mov bx,VARI         ;bx = i
	sub bx,ax           ;bx = bx - ax = i - 4*i = -3*i
	add bx,2            ;bx+=2
	push bx				;ret bx
	jmp f2_c

f2_1:   				; если a>b, то считаем 2*(i+1)-4 = 2*i - 2
	mov bx,VARI			;bx = i
	shl bx,1			;bx *= 2
	sub bx,2			;bx = bx - 2 = 2*i - 2
	push bx				;ret bx
	jmp f2_c

f2_c:
	jmp f2_end
	

f3: 
   mov 	ax,VARK			;ax = *si	(k)
   cmp	ax,0			;cmp k,0
   jl	f3_1_1			;если k < 0

f3_2_1:					;если k>=0
	mov ax,VARI2		;ax = i2
	cmp ax,0 			;сравниваем i2 c 0
	jl f3_2_c1          ;если i2 < 0

f3_2_2:
	sub ax,3            ;ax = |i2|-3
	cmp ax,4            ;сравниваем |i2|-3 с 4
	jg f3_1_c           ;если |i2|-3 > 4
	mov ax,4			;если |i2|-3 <=4, то ax = 4
	jmp f3_1_c          ;переключаемся на метку, в которой отправляем ax в стек




f3_2_c1:                ;если i2 < 0
	neg ax              ;меняем знак у i2
	jmp f3_2_2




f3_2_c:					;else
	push VARI2			;ret i1
	jmp f3_c		

f3_1_1:   				;если k < 0, то считаем |i1|-|i2|
	mov ax,VARI1		;в ax переменная i1
	cmp ax,0			;проверяем ax положительна ли
	jl f3_1_c1			;если отрицательна, то умножаем на -1

f3_1_2:					;продолжаем, в ax лежит |i1| теперь делаем то же с bx
	mov bx,VARI2        ;в bx переменная i2
	cmp bx,0            ;сравниваем bx с 0
	jl f3_1_c2          ;если bx отрицательна

f3_1:
	sub ax,bx			;ax = ax-bx = |i1|-|i2|
	jmp f3_1_c

f3_1_c1:                ;если ax(i1) отрицательна
	neg ax              ;меняем знак у i1
	jmp f3_1_2

f3_1_c2: 				;если bx(i2) отрицательна
	neg bx              ;меняем знак у i2
	jmp f3_1


f3_1_c:								
	push ax				;записываем в стек ax
	jmp f3_c
		
f3_c:
	jmp f3_end
 
Main      ENDP
CODE      ENDS
END Main				;ENDS CODE
