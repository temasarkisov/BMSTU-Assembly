CodeS SEGMENT para public 'CODE'
	assume SS:CodeS, CS:CodeS, DS:CodeS, ES:CodeS

org 100h
Start:
jmp Init

My_output_string proc
    cmp AH, 09
    je Is_cmd_09

    jmp dword ptr CS:[Int_21h_vect]

    Is_cmd_09:
        push DS
        push DX
        push CS
        pop DS

        mov DX, offset My_string
        pushf  ; Сохраняем флаги
        call dword ptr CS:[Int_21h_vect]

        pop DX
        pop DS
        iret  ; Микропроцессор выполнит возврат к основной программе

    Int_21h_vect dd ?
    My_string db 'YOUR STRING WAS HACKED!$'
My_output_string endp

Init:
    mov AH, 35h
    mov AL, 21h
    int 21h  ; В es:bx адрес прерывания 21h 

    mov word ptr Int_21h_vect, BX  ; Записываем смещение
    mov word ptr Int_21h_vect+2, ES  ; В старшие два байта записываем адрес сегмента 

    mov AH, 25h
    mov AL, 21h
    mov DX, offset My_output_string  ; DX - смещение нашего разработчика (DS - сегмент)
    int 21h

    mov DX, offset Init  ; Последний байт, оставляемый в памяти
    int 27h  ; Сделать резидента

CodeS ENDS
end Start