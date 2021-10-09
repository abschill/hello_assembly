org 0x7C00
bits 16

%define CRLF 0x0D, 0x0A 

start:
    jmp main


; print string
; params: 
; - ds:si points to string
puts: 
    push si
    push ax
    push bx

.loop:
    lodsb ;loads next char into al
    or al, al ;verify is next char null
    jz .done

    mov ah, 0x0E        ;call interrupt
    mov bh, 0           ; set page number to 0
    int 0x10

    jmp .loop


.done:
    pop bx
    pop ax
    pop si
    ret


main:
    ; data segments
    mov ax, 0 
    mov ds, ax
    mov es, ax

    ; setup fifo stack to save return addy when calling fn
    mov ss, ax
    mov sp, 0x7C00 ;grows downward from load src

    mov si, msg
    call puts

    hlt

.halt:
    jmp .halt

msg: db 'Hello there', CRLF, 0

times 510-($-$$) db 0
dw 0AA55h