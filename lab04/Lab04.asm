StkS SEGMENT PARA STACK 'STACK'
    db 100h dup(0)
StkS ENDS

DataS SEGMENT para public 'DATA'
    ROWS db 1 dup(0)
    COLUMNS db 1 dup(0)  
	MATRIX db 81 dup(0)
    INDEX db 1 dup(0)
    SAVE_ROW db 1 dup(0)
DataS ENDS

CodeS SEGMENT para public 'CODE'
	assume SS:StkS, CS:CodeS, DS:DataS

input_size:
	mov AH, 1
	
    int 21h
    mov ROWS, AL
    int 21h  ;Get separate symbol 
    
    int 21h
    mov COLUMNS, AL
    int 21h  ;Get separate symbol

	ret

input_matrix:
    mov DH, ROWS  ;Use DH as counter value save
    sub DH, 30h

    mov BX, 0  ;Use BX as index

    mov CH, 0
    mov CL, DH

    outside_cycle:
        mov AH, 1

        mov CL, COLUMNS
        sub CL, 30h

        row_cycle:
            int 21h
            mov MATRIX[BX], AL
            int 21h  ;Get separate symbol
            inc BX
        loop row_cycle

        mov CL, COLUMNS
        sub CL, 30h
        add BX, 9
        sub BX, CX

        mov CL, DH
        dec DH
    loop outside_cycle

    ret

output_matrix:
    mov AH, 2
    
    mov DL, 10  ;\
    int 21h     ; \ Get new
    mov DL, 13  ; /   line
    int 21h     ;/

    mov DH, ROWS  ;Use DH as counter value save
    sub DH, 30h

    mov BX, 0  ;Use BX as index

    mov CH, 0
    mov CL, DH

    print_cycle:
        mov CL, COLUMNS
        sub CL, 30h

        print_row_cicle:
            mov DL, MATRIX[BX]
            int 21h
            inc BX

            mov DL, 32
            int 21h
        loop print_row_cicle

        mov CL, COLUMNS
        sub CL, 30h
        add BX, 9
        sub BX, CX

        mov DL, 10  ;\
        int 21h     ; \ Get new
        mov DL, 13  ; /   line
        int 21h     ;/

        mov CL, DH
        dec DH
    loop print_cycle

    ret

change_column:
;    mov MATRIX[BX], 42
    
    mov AX, BX  ;Use AX as current index (processing_matrix) save
    mov SAVE_ROW, CL
    
    mov CL, COLUMNS
    sub CL, 30h

    mov BX, 0
    mov BL, INDEX
    
    change_column_cycle:
        mov MATRIX[BX], 42
        add BX, 9
    loop change_column_cycle

    mov CL, SAVE_ROW
    mov BX, AX

    ret

condition_second:
    cmp MATRIX[BX], 57  ;MATRIX[BX] <= 9
    jle change_column 
    ret 

condition:
    cmp MATRIX[BX], 48  ;MATRIX[BX] >= 0
    jge condition_second
    ret

processing_matrix:
    mov INDEX, 0
    mov DH, ROWS  ;Use DH as counter value save 
    sub DH, 30h

    mov BX, 0  ;Use BX as index

    mov CH, 0
    mov CL, DH

    processing_cycle:
        mov CL, COLUMNS
        sub CL, 30h

        processing_row_cycle:
            call condition
            inc BX
            inc INDEX
        loop processing_row_cycle
        
        mov CL, COLUMNS
        sub CL, 30h
        add BX, 9
        sub BX, CX
        mov INDEX, 0

        mov CL, DH
        dec DH
    loop processing_cycle

    ret 

main:
	mov AX, DataS
	mov DS, AX

	call input_size 
    call input_matrix
    call output_matrix
    call processing_matrix
    call output_matrix

	mov AH, 4Ch
	int 21h
CodeS ENDS
    END main
