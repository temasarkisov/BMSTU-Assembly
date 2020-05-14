PUBLIC numInput
PUBLIC convertToUD
PUBLIC convertToSH

StkS SEGMENT PARA STACK 'STACK'
    db 100h dup(0)
StkS ENDS

DataConvertS SEGMENT para public 'DATA'
    NUMBERUB dw 0
    REV_FLAG db 0
    NUMREQ db 13
           db 10
           db "Input number: "
           db "$"
DataConvertS ENDS

CodeS SEGMENT para public 'CODE'
	assume CS:CodeS, DS:DataConvertS

signDataConvert:
    assume DS:DataConvertS
    mov AX, DataConvertS
    mov DS, AX

    mov AX, StkS
    mov SS, AX
    
	ret

numInput proc far
    call signDataConvert

    mov AH, 09
    lea DX, NUMREQ
    int 21h

    xor DX, DX
    mov CX, 17
    readDigit:
        mov AH, 01
        int 21h
        sub AL, '0'
        sal DX, 1
        add DL, AL
    loop readDigit
    
    endRead:
        mov NUMBERUB, DX
        mov CX, 2

    ret
numInput endp

revNumber:
    not NUMBERUB
    inc NUMBERUB
    
    ret

convertToUD proc far
    call signDataConvert
    mov AX, NUMBERUB    

    setUD:  
        xor cx, cx
        mov bx, 10 
    oi2:
        xor dx, dx
        div bx
        push dx
        inc cx
        test ax, ax
        jnz oi2  ; Если содержимое AX не равно нулю

        mov ah, 02h
    oi3:
        pop dx
    oi4:
        add dl, '0'
        int 21h
        loop oi3
    
    ret
convertToUD endp

convertToSH proc far
    call signDataConvert
    mov AX, NUMBERUB    

    MOV DL, '+'
    SAL BH, 1
    MOV REV_FLAG, 0
    JNC @IFNOT
        MOV DL, "-"
        MOV REV_FLAG, 1
        call revNumber
    @IFNOT:
    MOV AH, 02h
    INT 21h
    MOV AX, NUMBERUB

    setSH:
        XOR CX, CX
        MOV BX, 16
    oi5:
        XOR DX, DX
        DIV BX
        PUSH DX
        INC CX
        TEST AX, AX
        JNZ oi5  ; Если содержимое AX не равно нулю
        MOV AH, 02h
    oi6:
        POP DX
        CMP DL,9
        JBE oi4
        ADD DL,7
    oi7:
        ADD DL, '0'
        INT 21h
        loop oi6
    CMP REV_FLAG, 1
    JE revNumber
    
    ret
convertToSH endp

CodeS ENDS
END