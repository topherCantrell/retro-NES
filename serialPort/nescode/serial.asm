.CPU 6502

.include serial_ram.asm
.include ../../include/NES.asm.md
.include ../../include/MEM.asm.md
.include ../../include/MMC1.asm.md

0xC000:

START:

; Clear all of RAM (including stack ... so don't make this a function)

    lda    #0                  ; RAM value (clear)
    ldx    #0                  ; Start address (0x0000)
_clear_ram:
    sta    0x0000,X            ; Clear ...
    sta    0x0100,X            ; ...
    sta    0x0200,X            ; ... all
    sta    0x0300,X            ; ... 
    sta    0x0400,X            ; ... 2KB
    sta    0x0500,X            ; ...
    sta    0x0600,X            ; ...
    sta    0x0700,X            ; ... of RAM
    inx                        ; Next address
    bne    _clear_ram          ; All of RAM

; Initialize the UART
    jsr    InitUART
    
; Copy default palette to our palette ram 
    #write_word(default_palette, GP0)
    #write_word(palette, GP1)
    #write_word(32, GP2)
    jsr    MEM_copy_large_block

; Copy image bit patterns to PPU    
    #write_word(ch20_2F_Patterns, GP0) ; Source
    #write_word(32*16, GP1)            ; Destination
    #write_word(26*16, GP2)            ; Size
    jsr    PPU_copy_block_to_vram
    ;
    #write_word(ch3A_40_Patterns, GP0) ; Source
    #write_word(58*16, GP1)            ; Destination
    #write_word(7*16, GP2)             ; Size
    jsr    PPU_copy_block_to_vram
    ;
    #write_word(ch41_5A_Patterns, GP0) ; Source
    #write_word(65*16, GP1)            ; Destination
    #write_word(26*16, GP2)            ; Size
    jsr    PPU_copy_block_to_vram
       
; Copy the name table and attributes to the PPU    
    #write_word(name_table, GP0)       ; Source
    #write_word(0x2000, GP1)           ; Destination
    #write_word(32*30, GP2)            ; Size
    jsr    PPU_copy_block_to_vram
    ;
    #write_word(attribute_table, GP0)  ; Source
    #write_word(0x23C0, GP1)           ; Destination
    #write_word(64, GP2)               ; Size
    jsr    PPU_copy_block_to_vram

; Print startup bank numbers
    #write_word(tv_greeting, GP0)
    #write_word(0x2040, GP1)    
    jsr    printString    

; Wait for another vblank flag
    bit    PPUSTATUS
_wait2:
    bit    PPUSTATUS           ; Wait for ...
    bpl    _wait2              ; ... vblank flag

; Enable NMI
    lda    #0b10001000         ; Enable NMI and configure name table use ...
    sta    PPUCTRL             ; ... BG=0, Sprites=1    

; Pring the serial monitor greeting    
    #write_word(serial_greeting, GP0)
    jsr    WriteString

    jsr    wait_ppu_update    

main:

; Read a string from the serial port
    #write_word(type_prompt, GP0)
    jsr    WriteString    

    jsr    ReadString

    #write_word(echo_greeting, GP0)
    jsr    WriteString

    #write_word(keybuffer, GP0)
    jsr    WriteString

    #write_word(crlf, GP0)
    jsr    WriteString

    jmp    main

; --------------------------
; UART specific
; --------------------------

.UART_CTL = 0x7C00
.UART_DATA = 0x7C01

InitUART:
    LDA    #0x03            ; Master ...
    STA    UART_CTL         ; ... reset
    LDA    #0x16            ; 8N1, div64
    STA    UART_CTL         ; Configure UART
    RTS                     ; Done

ReadByte:
_readu1:
    LDA    UART_CTL         ; Wait ...
    LSR    A                ; ... for ...
    BCC    _readu1          ; ... data
    LDA    UART_DATA        ; Get the character
    RTS                     ; Done

WriteByte:
    PHA                     ; Hold outgoing value
_writeu1:
    LDA    UART_CTL         ; Buffer ...
    LSR    A                ; ... is ...
    LSR    A                ; ... full?
    BCC    _writeu1         ; Yes ... wait
    PLA                     ; Restore outgoing value
    STA    UART_DATA        ; Send the data
    RTS                     ; Done

WriteString:
    LDY    #0               ; 0 index
_wstr:
    LDA    (GP0),Y          ; Get the character
    BEQ    _wstr_done       ; Done
    JSR    WriteByte        ; Write the character
    INY                     ; Next character
    JMP    _wstr            ; Next character
_wstr_done:
    RTS                     ; Done

ReadString:
; Reads into "keybuffer" until LF. Adds null terminator on end.
; Max length is 254 characters (always a terminator).
    ldx    #0                  ; Start with an ...
    lda    #0                  ; ... empty ...
    sta    keybuffer,X         ; ... buffer

_rs_loop:
    jsr    ReadByte            ; Get a character
    jsr    WriteByte           ; Echo the character
    cmp    #0x0D               ; Is it a CR?
    beq    _rs_done            ; Yes ... done
    cmp    #0x08               ; Is it a backspace?
    bne    _rs_store           ; No ... store it
    dex                        ; Back up
    bpl    _rs_loop            ; Didn't underflow ... keep going
    inx                        ; Back to 0
    jmp    _rs_loop            ; Keep going

_rs_store:
    sta    keybuffer,X         ; Store the character
    inx                        ; Next character
    bne    _rs_loop            ; No overflow ... keep going
    dex                        ; limit buffer
    jmp    _rs_loop            ; Keep going

_rs_done:
    lda    #0                  ; Null terminator
    sta    keybuffer,X         ; Store the terminator
    lda    #0x0A               ; LF
    jsr    WriteByte           ; Echo the LF
    rts                        ; Done

serial_greeting:
. byte 13,10,"Serial Monitor Program",13,10,0

type_prompt:
. byte "Type something: ",0

echo_greeting:
. byte "You typed: ",0

crlf:
. byte 13,10,0

tv_greeting:
. byte "SERIAL MONITOR PROGRAM",0

; ==========================================================================

default_palette:
. byte 0x0F, 0x15, 0x26, 0x37
. byte 0x0F, 0x09, 0x19, 0x29
. byte 0x0F, 0x01, 0x11, 0x21
. byte 0x0F, 0x00, 0x10, 0x30
. byte 0x0F, 0x18, 0x28, 0x38
. byte 0x0F, 0x14, 0x24, 0x34
. byte 0x0F, 0x1B, 0x2B, 0x3B
. byte 0x0F, 0x12, 0x22, 0x32

name_table:
. byte 65,65,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,66,66
. byte 65,65,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,66,66
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
. byte 67,67,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,68,68
. byte 67,67,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,68,68

attribute_table:
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.include ../../include/MMC1_impl.asm
.include ../../include/ascii_obj.asm
.include ../../include/NMI_impl.asm
.include ../../include/MEM_impl.asm
.include../../include/NES_impl.asm

0xFF50:
.include ../../include/RESET_impl.asm

0xFFFA:
. word NMI
. word RESET
. word IRQ