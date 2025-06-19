; ==================================================================
; LunaOS
; An Operating System kernel written in Assembly by Pabodha Wanniarachchi. 
; This OS is inspired by MikeOS.
; ==================================================================

BITS 16
ORG 0000h


start:
    mov ax, cs    ; Copy the value of the Code Segment into AX
    mov ds, ax    ; Set DS (Data Segment) = CS
    mov es, ax    ; Set ES (Extra Segment) = CS

    call clear_screen

    mov si,welcome_string
    call print_string

main_loop:
    call print_prompt

    mov di, user_input
    call read_string

    ; Compare user input with "info"
    mov si, user_input
    mov di, info_cmd
    call new_line
    call compare_strings
    cmp al, 1
    je show_info    ; If match, jump to show_info

    ; Compare user input with "help"
    mov si, user_input
    mov di, help_cmd
    call new_line
    call compare_strings
    cmp al, 1
    je handle_help  ; If match, jump to handle_help

    ; Compare user input with "clear"
    mov si, user_input
    mov di, clear_cmd
    call new_line
    call compare_strings
    cmp al, 1
    je handle_clear         ; If match, jump to handle_clear

    mov si,unknown_cmd
    call print_string       ; If not matched, print Unown commans and restart
    jmp main_loop       


clear_screen:
    pusha
    mov ah, 0x00        ; Set video mode function
    mov al, 0x03        ; Text mode 80x25, 16 colors
    int 10h             ; Call BIOS interrupt
    popa
    ret


print_string:
    mov ah, 0Eh		; AH+AL=AX. use 0Eh to print characters in teletype mode
	.repeat:
		lodsb		; Load byte at DS:SI into AL and increment SI
		cmp al, 0	; Check if that character is null (end of string)
		je .done	
		int 10h		; Print character in AL
		jmp .repeat
	.done:
		ret


print_prompt:
    pusha

    mov si, prompt_string
    call print_string
    popa
    ret


read_string:
    pusha
    mov bx, di				; Need for backspace handling to prevent deleting characters before the buffer's beginning.
	.read_loop:
		mov ah, 00h 		; BIOS function to read a character from the keyboard of BIOS Interrupt 16h
		int 16h			 	; after this AL contains the ASCII code of the key pressed, AH contains the scan code of the key.
		cmp al, 0Dh			; 0Dh - ASCII for ENTER key
		je .done_reading
		cmp al, 08h			; 08h - ASCII value for "Backspace" key
		je .backspace
		mov [di], al		; Store the character in the buffer at DI
		mov ah, 0Eh         ; Set AH register to 0Eh, which is BIOS function for - (PRINT THE SCAN CODE TO SCREEN(AL))
		int 10h				; Print the character on the screen
		inc di			 	; Increment DI to point to the next position in the buffer
		jmp .read_loop

	.backspace:
		cmp di, bx			; Check if DI is at the start of the buffer
		je .read_loop
		dec di			    ; Move DI back to the previous character
		mov byte [di], 0	; Clear the character from the buffer
		mov ah, 0Eh			; 
		mov al, 08h			; 08h is the ASCII value for "Backspace" key
		int 10h
		mov al, ' '
		int 10h
		mov al, 08h			; After printing the space, the cursor has moved one position right. 
		int 10h				; We need to move it back to the left so that the next character typed appears correctly.
		jmp .read_loop

	.done_reading:
		mov byte [di], 0	; Null-terminate the string in the buffer
		popa				; Restore the values of all general-purpose 16-bit registers from the stack.
		ret


compare_strings:
    push si
    push di
    .compare_loop:
        mov al, [si]        ; Load character from SI = INPUT
        mov bl, [di]        ; Load character from DI = COMMAND TO COMPARE
        cmp al, bl
        jne .not_equal      ; If mismatch, fail
        cmp al, 0
        je .equal           ; If both reached null, success
        inc si
        inc di
        jmp .compare_loop

    .equal:
        mov al, 1
        pop si
        pop di
        ret

    .not_equal:
        mov al, 0
        pop si
        pop di
        ret

new_line:
    mov ah, 0x0E    ; AH = 0x0E tells int 10h that you want to print a character on the screen, like a typewriter.
    mov al, 0Ah     ; Line Feed (WEN DOWN ARROW KEY PRESSED)
    int 10h
    mov al, 0Dh     ; Carriage Return(WHEN HIT ENTER)
    int 10h
    ret

print_decimal:
    pusha
    mov cx, 0
    mov bx, 10

    .divide_loop:
        mov dx, 0
        div bx              ; AX / 10, result in AX, remainder in DX
        push dx
        inc cx
        cmp ax, 0
        jne .divide_loop

    .print_loop:
        pop dx
        add dl, '0'
        mov ah, 0x0E
        mov al, dl
        int 10h
        loop .print_loop

        popa
        ret


; Print ' KB'
print_kb_suffix:
    mov si, kb_label
    call print_string
    call new_line
    ret


print_M_suffix:
    pusha
    mov si, mb_label
    call print_string
    popa
    ret


show_info:
    call new_line
    call detect_cpu
    call detect_base_memory
    call detect_mid_memory
    call detect_high_memory
    call detect_hard_drives
    call detect_serial_ports
    call detect_serial_port1
    call detect_mouse
    
    jmp main_loop

handle_clear:
    call clear_screen
    jmp main_loop


handle_help:
    
    mov si,help_str
    call print_string
    call new_line
    jmp main_loop           

detect_cpu:

    ;------CPU vendor------
    mov si,vendor_label
    call print_string
    
    mov eax,0           ;it prepares the CPU to respond with the vendor ID string when you run cpuid
    cpuid               ;cpuid is an x86 CPU instruction that gives information about the CPU  

    ;after running cpuid with EAX=0, the CPU fills: EBX = first 4 letters of vendor string , EDX = next 4 letters ,ECX = last 4 letters
    mov [cpu_vendor+0],ebx          ;store from the first 4 bytes 0,1,2,3
    mov [cpu_vendor+4],edx          ;store from tHe second 4 bytes 4,5,6,7
    mov [cpu_vendor+8],ecx
    mov si,cpu_vendor
    call print_string
    call new_line

    mov si, cpu_desc_label
    call print_string
    mov eax, 0x80000002
    cpuid
    mov [cpu_type+0], eax
    mov [cpu_type+4], ebx
    mov [cpu_type+8], ecx
    mov [cpu_type+12], edx
    mov eax, 0x80000003
    cpuid
    mov [cpu_type+16], eax
    mov [cpu_type+20], ebx
    mov [cpu_type+24], ecx
    mov [cpu_type+28], edx
    mov eax, 0x80000004
    cpuid
    mov [cpu_type+32], eax
    mov [cpu_type+36], ebx
    mov [cpu_type+40], ecx
    mov [cpu_type+44], edx
    mov si, cpu_type
    call print_string
    call new_line
    ret

; Detect Base Memory (INT 12h)
; -----------------------------
detect_base_memory:
    mov si, base_memory_label
    call print_string
    mov ah,0x0
    mov [base_mem], ax
    int 0x12          ; AX = base memory in KB
    call print_decimal
    call print_kb_suffix
    ret


; Detect Extended Memory (INT 15h, AH=88h)
; -----------------------------
detect_mid_memory:
    mov si, mid_memory_label
    call print_string
    mov ah, 0x88
    int 0x15          ; AX = extended memory in KB
    mov [mid_mem], ax
    call print_decimal
    call print_kb_suffix
    ret

; Get Memory Above 16MB
detect_high_memory:
    pusha
    mov si, high_memory_label
    call print_string

    mov ax, 0xE801
    int 15h
    jc .no_e801                  ; If unsupported, skip

    cmp dx, 0
    je .no_e801

    ; DX = number of 64KB blocks above 16MB
     mov [high_mem_64k_blocks], cx
    mov [high_mem_64k_blocks], dx
    mov dx, 0
    mov ax, [high_mem_64k_blocks]
    mov cx ,16
    div cx                     ; AX = memory above 16MB in MB
    mov [high_mem_mb], ax
    call print_decimal
    call print_M_suffix
    call new_line
    jmp .sum_total

.no_e801:
    mov si, not_supported_str
    call print_string
    mov word [high_mem_mb], 0
    call new_line

.sum_total:
    mov si, total_memory
    call print_string

    ; Start with 0
    mov eax, 0

    ; Base Memory
    movzx ebx, word [base_mem]
    add eax, ebx

    ; Mid Memory
    movzx ebx, word [mid_mem]
    add eax, ebx

    ; High Memory: MB to KB
    movzx ebx, word [high_mem_mb]
    imul ebx, 1024
    add eax, ebx

    ; Convert total KB to MB
    mov edx, 0
    mov ecx, 1024
    div ecx

    call print_decimal
    call print_M_suffix
    call new_line
    popa
    ret

detect_hard_drives:
    pusha                            ; Save all general purpose registers

    mov si, hdd_label                ; Show label: "Hard Drives: "
    call print_string

    ; Set ES to BIOS Data Area segment (0x40)
    mov ax, 0x0040
    mov es, ax

    ; Load number of hard disks from [ES:0x0075]
    mov al, [es:0x0075]
    mov ah, 0                        ; Clear upper byte (make AX = AL)

    call print_decimal              ; Print number of hard drives
    call new_line

    popa                             ; Restore registers
    ret
; Detect serial ports from BIOS Data Area

detect_serial_ports:
    pusha

    mov si, serial_port_label
    call print_string

    mov cx, 0            ; Counter for serial ports
    mov di, 0            ; Offset = 0040:0000 is COM1 base

.next_port:
    mov dx, [es:di]      ; Get the port address
    cmp dx, 0
    je .skip
    inc cx
.skip:
    add di, 2            ; Move to next port address (2 bytes each)
    cmp di, 8            ; 4 COM ports = 8 bytes
    jl .next_port

    mov ax, cx
    call print_decimal

    
    call new_line

    popa
    ret

; Detect Serial Port 1 (COM1) Base I/O Address
; -----------------------------------------
detect_serial_port1:
    mov si, serial_label
    call print_string

    push es
    mov ax, 0x0040        ; BIOS Data Area segment
    mov es, ax

    mov ax, [es:0x0000]   ; COM1 base address is at 0040:0000
    pop es

    call print_decimal
    call new_line
    ret


; Detect Mouse
; ----------------------------
detect_mouse:
    mov si,mouse_label
    call print_string
    pusha
    mov ax, 0x0000       ; Mouse reset & presence check function
    int 0x33             ; BIOS Mouse interrupt

    cmp ax, 0
    je .no_mouse         ; AX=0 → Mouse not present

    ; Mouse is present
    mov si, mouse_found_str
    call print_string
    call new_line
    popa
    ret

.no_mouse:
    mov si, mouse_notfound_str
    call print_string
    call new_line
    popa
    ret



; ==================================================================
; KERNEL DATA
; ==================================================================

welcome_string      db 'Welcome to LunaOS by Pabodha Wanniarachchi!', 0
prompt_string       db 0x0A, 0x0D, "lunaOS >> ", 0
info_cmd            db 'info', 0
unknown_cmd         db "unknown Command", 0
help_cmd            db "help", 0
clear_cmd           db "clear", 0

vendor_label        db 'CPU Vendor: ', 0
cpu_desc_label      db "CPU description: ", 0
base_memory_label   db "Base Memory: ", 0
mid_memory_label       db 'Extended Memory between (1M - 16M): ', 0
high_memory_label      db "Extended memory above 16M : ", 0
total_memory           db "Total usable memory: ", 0
not_supported_str db 'Not supported', 0
hdd_label           db "Number of hard drives: ", 0
serial_port_label   db "Number of serial port: ", 0
serial_label        db "COM1 Base I/O Address: ", 0
mouse_label         db "Mouse status: ", 0


help_str            db "info-Hardware information", 0Dh, 0Ah, "clear-Clear Screen", 0Dh, 0Ah, 0
mouse_found_str     db "Found", 0
mouse_notfound_str  db "Not Found", 0
kb_label: db ' KB', 0
mb_label: db  " MB", 0

mem_total: dw 0
memory_buffer: times 24 db 0   ; Buffer to hold memory map entries

base_mem     dw 0
mid_mem      dw 0
high_mem     dw 0
high_mem_mb  dw 0
total_mem    dw 0
high_mem_64k_blocks    dw 0

user_input          times 32 db 0
cpu_vendor          times 13 db 0
cpu_type            times 49 db 0


; -------------------------------
; Boot signature
; -------------------------------
;times 510-($-$$) db 0
dw 0xAA55
