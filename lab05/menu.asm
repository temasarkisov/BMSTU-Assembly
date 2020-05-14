PUBLIC menuOutput
PUBLIC cmdPtrArrayInit
PUBLIC cmdCall

EXTRN numInput: far
EXTRN convertToUD: far
EXTRN convertToSH: far

StkS SEGMENT PARA STACK 'STACK'
    db 100h dup(0)
StkS ENDS

DataMenuS SEGMENT para public 'DATA'
    CMDPTRARRAY dw 4 dup("$$")
    MENUINFO db 13
             db 10
             db "1 - Enter number (unsigned binary)."
             db 13 
             db 10
             db "2 - Convert to unsigned decimal." 
             db 13
             db 10
             db "3 - Convert to signed hexadecimal."
             db 13
             db 10
             db "0 - Exit."
             db 13
             db 10
             db "$"
    OPERNUMREQ db 13
               db 10
               db "Input operation number: "
               db "$"
    EXITMSG db 13
            db 10
            db "Good bye!"
            db "$"
DataMenuS ENDS

CodeS SEGMENT para public 'CODE'
	assume CS:CodeS, DS:DataMenuS

signDataMenu:
    assume DS:DataMenuS
    mov AX, DataMenuS
    mov DS, AX

    mov AX, StkS
    mov SS, AX
    
    ret

cmdPtrArrayInit proc far
    call signDataMenu

    lea BX, exit
    mov CMDPTRARRAY[0], BX
    lea BX, numInputCall
    mov CMDPTRARRAY[2], BX
    lea DX, convertToUDCall
    mov CMDPTRARRAY[4], DX
    lea DX, convertToSHCall
    mov CMDPTRARRAY[6], DX

    ret
cmdPtrArrayInit endp

menuOutput proc far
    call signDataMenu

    mov AH, 09
    lea DX, MENUINFO
    int 21h

    ret
menuOutput endp

cmdCall proc far
    call signDataMenu

    mov AH, 09
    lea DX, OPERNUMREQ
    int 21h

    mov AH, 01
    int 21h

    mov BH, 0
    mov BL, AL
    add BL, AL
    sub BL, 30h
    sub BL, 30h

    mov AH, 02  ;\
    mov DL, 10  ; \
    int 21h     ;  > Get new
    mov DL, 13  ; /  line
    int 21h     ;/

    call CMDPTRARRAY[BX]

    ret
cmdCall endp

numInputCall:
    call numInput

    ret

convertToUDCall:
    call convertToUD 
    
    ret

convertToSHCall:
    call convertToSH

    ret

exit:
    call signDataMenu
    mov CX, 1

    mov AH, 09
    lea DX, EXITMSG
    int 21h

    ret

CodeS ENDS
END