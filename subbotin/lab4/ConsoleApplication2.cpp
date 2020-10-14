#include <iostream>
#include <stdio.h>

#define N 80
using namespace std;

int main()
{
	system("chcp 1251 > nul");
	char _str[N + 1];
	cout << "ЛР4. Субботин Максим 9382. \n 20. Заменить введенные во входной строке русские буквы на числа, соответствующие их номеру по алфавиту, представленному в шестнадцатиричной СС, остальные символы входной строки передать в выходную строку непосредственно.\n";
	char str_out[N * 2 + 1];
	int i = 0;
	cin.getline(_str, N);
	_asm {
		sub eax, eax;
		mov al, 0;		in al code of str ending symbol
			mov ecx, N;	    ecx = N
			lea edi, _str;	edi now points at start of _str
			repne scas; 	ecx now contains N - str.length
			sub ecx, N; 	ecx = -str.length
			neg ecx;		ecx = str.length
			mov edx, ecx;    edx = ecx
			sub edi, edi; 	edi == 0
			sub esi, esi;    esi == 0

			traverse:
		mov edi, edx;	edi = edx
			sub edi, ecx;	edi - points at last element in str, when we subtracting ecx we pointing to currentIdx, as ecx decreasing every iteration

			mov al, _str[edi];	al contains currentElement

			cmp al, 'Ё';	check ё separately
			je isYo;
		cmp al, 'ё';
		je isYo;
		; table: ... A - Я, а - я ...
			cmp al, 'А';	if symbol < A, then its not cyrilic
			jl writeSymbol;
		cmp al, 'я';	if symbol > я, then its also not cyrilic
			jg writeSymbol;

		; letter is cyrillic
			cmp al, 'а';
		jge aSmalltoYaSmall; if al in а - я

			; letter is big
			; if al in A - Я
			cmp al, 'Е';
		jle beforeYo;		 if letter is in A - E
			inc al;	Letters after ё are one position bigger

			beforeYo : ; letter is in A - E
			sub al, 'А';
		inc al;			     now in al alphabetical position of current letter
			jmp insertHex

			aSmalltoYaSmall : ; if currentElement in а - я
			cmp al, 'е';
		jle beforeYoSmall;	if currentElement in a - е
			inc al;				if currentElement in ж - я

			beforeYoSmall : ; currentElement in а - е
			sub al, 'а';
		inc al;				now in al alphabetical index
			jmp insertHex

			isYo :
		mov al, 7

			insertHex :
			cmp al, 31
			jg greatest
			cmp al, 15
			jg middle
			mov str_out[esi], '0'
			jmp secondNumb

			greatest :
		mov str_out[esi], '2'
			sub al, 32
			jmp secondNumb

			middle :
		mov str_out[esi], '1'
			sub al, 16

			secondNumb :
			inc esi
			cmp al, 9
			jg greaterLast
			add al, 48
			jmp writeSymbol

			greaterLast :
		add al, 55

			writeSymbol :
			mov str_out[esi], al
			inc esi
			loop traverse;

		mov str_out[esi], 0
	}
	cout << str_out;
	return 0;
}

