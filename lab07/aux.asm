section .text

global asm_copy


asm_copy:
    mov RCX, RDX  ; Передача длины строки

    cmp RDI, RSI    
    jne notEqualPtr
    ret

notEqualPtr:
    cmp RDI, RSI
    jl simple_copy

    mov RBX, RDI
    sub RBX, RSI

    cmp RBX, RCX
    jl  rev_copy
    jge simple_copy

rev_copy:
    add RDI, RCX
    add RSI, RCX
    dec RSI
    dec RDI
    STD  ; DF = 1
    repnz movsb
    
simple_copy:
    repnz movsb  ; Побайтовое копирование
    ret
