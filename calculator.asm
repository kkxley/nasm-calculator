%include        'functions.asm'

SECTION .data
msg1        db      ' остаток ', 0
msg2        db      '-----------------', 0
msg3        db      'нельзя делить на ноль', 0

SECTION .bss
input:      resb    255
opc:        resb    2

SECTION .text
global  _start

_start: 

    call str2int; вводим первое число
    push ebx; сохраняем его
    
    mov ebx,0
    mov ecx,opc
    mov edx,2
    mov eax,3
    int 80h

    call str2int; вводим второе число
    push ebx; сохраняем его

    mov eax, msg2
    call    sprintLF

    mov ah, [opc]
    sub ah, '0'

    cmp ah, 251
    je add    
    cmp ah, 253
    je sub
    cmp ah, 250
    je mul
    cmp ah, 255
    je del
    
    call    quit

add:
    pop ebx ; достаем второе число
    mov edx, ebx ; сохроняем второе число
    pop ebx ; достаем певое число
    mov eax, ebx ; сохроняем второе число
    mov ebx, edx
    
    add     eax, ebx
    call    iprintLF
    call    quit

sub:
    pop ebx ; достаем второе число
    mov edx, ebx ; сохроняем второе число
    pop ebx ; достаем певое число
    mov eax, ebx ; сохроняем второе число
    mov ebx, edx
    
    sub     eax, ebx
    call    iprintLF
    call    quit

mul:
    pop ebx ; достаем второе число
    mov edx, ebx ; сохроняем второе число
    pop ebx ; достаем певое число
    mov eax, ebx ; сохроняем второе число
    mov ebx, edx
    
    mul     ebx
    call    iprintLF
    call    quit

del:
    pop ebx ; достаем второе число
    mov ecx, ebx ; сохроняем второе число
    pop ebx ; достаем певое число
    mov eax, ebx ; сохроняем второе число
    mov ebx, ecx
    
    cmp ebx, 0
    je devOnNull

    div     ebx         ; целая часть
    call    iprint      ; выводим
    mov     eax, msg1   ; выводим сообщение об остатке      
    call sprint
    mov     eax, edx    ; перекладываем остаток и выводим
    call    iprintLF
    call    quit

devOnNull:
    mov eax, msg3
    call sprintLF
    call    quit

inputValue:
    mov     edx, 255        ; сколько символов считывать
    mov     ecx, input     ; куда класть
    mov     ebx, 0          ; источник STDIN
    mov     eax, 3          ; вызов ядра SYS_READ
    int     80h
    ret

str2int:
    call inputValue
    mov     ecx, 0; объявляем счетчик
    mov     ebx, 0; обнуляем число 
    nextNumber:
        mov     eax,10 ; eax = 10 
        mul     ebx; умножаем старое число
        mov     ebx,eax; ebx=eax 
        mov     al, [input+ecx]; берем символ
        sub     al, '0'; из чтроки в число
        movzx   eax, al 
        add     ebx,eax; добоаляем его в число
        inc     ecx; увеличиваем счетчик
        movzx   eax, byte[input+ecx]
        cmp     eax, 10
        jne     nextNumber
    ret