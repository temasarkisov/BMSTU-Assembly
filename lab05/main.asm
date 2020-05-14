EXTRN menuOutput: far
EXTRN cmdPtrArrayInit: far
EXTRN cmdCall: far

StkS SEGMENT PARA STACK 'STACK'
    db 100h dup(0)
StkS ENDS

DataMainS SEGMENT para public 'DATA'
    db 100h dup(0)
DataMainS ENDS

CodeS SEGMENT para public 'CODE'
	assume SS:StkS, CS:CodeS, DS:DataMainS

signDataMain:
    assume DS:DataMainS
    mov AX, DataMainS
    mov DS, AX

    mov AX, StkS
    mov SS, AX
    
	ret

main:
	call signDataMain
    call cmdPtrArrayInit

	menu:
		call menuOutput
    	call cmdCall
	loop menu

	mov AX, 4c00h
	int 21h
CodeS ENDS
END main


