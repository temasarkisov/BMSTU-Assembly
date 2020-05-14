SD1 SEGMENT para public 'DATA'
	S1 db '9'
    S2 db '3'
SD1 ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD1
input:
	mov ah, 1
	int 21h
	ret
output:
	mov ah, 2
	int 21h
	mov dl, 13
	int 21h
	mov dl, 10
	int 21h
	ret
main:
	mov ax, SD1
	mov ds, ax

	call input 
	mov S1, al
	call input

	call input 
	mov S2, al
	call input

	mov al, S1
	sub al, S2
	add al, '0'
	mov S1, al

	mov dl, S1
	call output

	mov ax, 4c00h
	int 21h
CSEG ENDS
END main
