org 100h
jmp START

_numberOperators EQU 7h
operatorString db ' +-*/^()' ;list of valid operators for IS_OPERATOR preceeded with a space

;This infinite loop reads a one character symbol from the keyboard and echoes it to the screen.
;Then calls IS_OPERATOR to find if it is true(1) or false(0) that the symbol is an operator.
;The '1' or '0' rv is sent to the screen and the screen advances to a new line. 
;Kill this infinite loop by clicking the window's x button

START:
mov ah, 07h		 ;Read symbol 
int 21h			 ;from keyboard. 
mov ah, 02h		 ;Echo 
mov dl, al		 ;symbol
int 21h			 ;to screen

push dx			 ;Push argument. The previous "mov dl, al" moved symbol into dl. 
call IS_OPERATOR ;Call IS_OPERATOR to find if input symbol is an operator.
pop dx			 ;This loads dl with rv (1 0r 0) to be echoed to screen.
mov ah, 02h	     ;Send rv
int 21h			 ;to screen

;Advance screen to new print line
mov ah, 02h
mov dl,0Dh
int 21h
mov dl,0Ah
int 21h
	 
jmp START		 ;Jump to START of infinite loop

;IS_OPERATOR returns true(1) or false(0) that the input parameter is an operator
IS_OPERATOR Proc

;Push 3 registers subrtn will use.
push ax							;Stores the input char in al 
push bx							;Used as subscript i in C++ version
push bp							;Stores sp

mov bp,sp						;mov sp to bp
mov ax,[bp+08h]						;mov argument (input char) to ax
mov bx, _numberOperators		;mov _numberOperators to bx
mov operatorString[0],al		;mov input char to beginning of operatorString; in C++ operatorString[0]=symbol;
	 
jmp WHILE_CONDITION             
WHILE_TOP:                      ;loop to see if input is an operator
dec bx							;in C++ i = i-1;
WHILE_CONDITION:
cmp	al,operatorString[bx]			;check to see if the input is equal to one of the operators:
jNE	WHILE_TOP						;in C++ if (symbol != operators[i])goto WHILE_TOP;

;If bx=0, symbol wasn't found in the original initialization of the array and return 0 (equivalent to false).
;Else symbol was part of the original initialization of the array and set bx=1 (equivalent to true).
cmp  bx,0							
je END_IF
mov bx,1						;set up to return 1 (the symbol is an operator).
END_IF:

;this line makes 0 into '0' and 1 into '1' so they will print to the screen in ascii
add bx,30h						;AFTER proving to me that your pgm works, remove this line

mov [bp+08h], bx							;mov bx (the rv) to the stack
 
;Restore registers subrtn used
pop bp							
pop bx							
pop ax							
ret  
IS_OPERATOR ENDP