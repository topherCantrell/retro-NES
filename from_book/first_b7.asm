.CPU 6502

.include first_ram.asm
.include NES.asm.md
.include MMC1.asm.md
.include MEM.asm.md

0xC000:

. byte 0x70  ; Bank identifier for reset experiment

START:

; Clear all of RAM (including stack ... so don't make this a function)

    lda    #0                  ; RAM value (clear)
    ldx    #0                  ; Start address (0x0000)
_clear_ram:
    ; sta    0x0000,X            ; Clear   TODO for now keep the bank id experiment values
    sta    0x0100,X            ; ...
    sta    0x0200,X            ; ... all
    sta    0x0300,X            ; ... 
    sta    0x0400,X            ; ... 2KB
    sta    0x0500,X            ; ...
    sta    0x0600,X            ; ...
    sta    0x0700,X            ; ... of RAM
    inx                        ; Next address
    bne    _clear_ram          ; All of RAM
    
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

; Print static
    #write_word(greeting, GP0)
    #write_word(0x2040, GP1)    
    jsr    printString

    #write_word(0x204C, GP1)
    lda    0x80
    jsr    printHexByte

    #write_word(0x205C, GP1)
    lda    0x81
    jsr    printHexByte

    #write_word(0x2086, GP1)
    lda    0x4016
    and    #0b11001
    jsr    printHexByte

    #write_word(0x208F, GP1)
    lda    0x4017
    and    #0b11001
    jsr    printHexByte

; Wait for another vblank flag
    bit    PPUSTATUS
_wait2:
    bit    PPUSTATUS           ; Wait for ...
    bpl    _wait2              ; ... vblank flag

; Enable NMI
    lda    #0b10001000         ; Enable NMI and configure name table use ...
    sta    PPUCTRL             ; ... BG=0, Sprites=1    

main:

    jsr    wait_ppu_update    

    jsr    read_byte           ; Read a serial byte

    ; 01 aa AA dd              - Write value dd to AAaa
    ; 02 aa AA                 - Read value from AAaa
    ;
    ; 03 aa AA ss dd dd dd ... - Write multiple values to AAaa+
    ; 04 aa AA ss              - Read multiple values from AAaa+
    ; 05 aa AA                 - Execute code at AAaa
    ; 06 aa AA ss dd dd dd ... - Write multiple values to PPU AAaa+
    ; 07 aa AA ss              - Read multiple values from PPU AAaa+
    ; Others ignored

    cmp    #1
    beq    CMD_write_byte
    cmp    #2
    beq    CMD_read_byte
    cmp    #3
    beq    CMD_write_bytes
    cmp    #4
    beq    CMD_read_bytes
    cmp    #5
    beq    CMD_execute
    cmp    #6
    beq    CMD_write_ppu
    cmp    #7
    beq    CMD_read_ppu
    jmp    main

CMD_write_byte:
    jsr    read_byte           ; Read address LSB
    sta    GP2                 ; Store it
    jsr    read_byte           ; Read address MSB
    sta    GP2+1               ; Store it   
    jsr    read_byte           ; Read data
    ldy    #0                  ; 0 index
    sta    (GP2),Y             ; Write the data
    jmp    main

CMD_read_byte:
    jsr    read_byte           ; Read address LSB
    sta    GP2                 ; Store it
    jsr    read_byte           ; Read address MSB
    sta    GP2+1               ; Store it   
    ldy    #0                  ; 0 index
    lda    (GP2),Y             ; Read the data
    jsr    write_byte          ; Send it to the monitor
    jmp    main

CMD_write_bytes:
CMD_read_bytes:
CMD_execute:
CMD_write_ppu:
CMD_read_ppu:
    jmp    main

read_byte:
; in-data is 0x4016 bit D0
; clock is 0x4016 bit D3    
    ldx    #8                  ; 8 bits
_read_all:
    ; Wait for clock to go low
_read1:
    lda    APU_JOYPAD1         ; Read controller port
    and    #0b0000_1000        ; Wait for CLOCK (inverted) ... 
    beq    _read1              ; ... to go low
    ; Wait for clock to go high
_read2:
    lda    APU_JOYPAD1         ; Read controller port
    and    #0b0000_1000        ; Wait for CLOCK (inverted) ...
    bne    _read2              ; ... to go high
    lda    APU_JOYPAD1         ; Read controller port
    eor    #255                ; Input is inverted. Flip the bits.
    ror    a                   ; DATA_IN to carry ...
    rol    GP0                 ; ... and to final value
    ; Repeat
    dex                        ; Do all ...
    bne    _read_all           ; ... 8 bits
    lda    GP0                 ; Return the value
    rts                        ; Done

write_byte:
; out-data is 0x4016 bit D0
; clock is 0x4016 bit D3
    sta    GP0                 ; The outgoing bits    
    ldx    #8                  ; 8 bits to move    
_write_all:
    ; Wait for clock to go low
_write1:
    lda    APU_JOYPAD1         ; Read controller port
    and    #0b0000_1000        ; Wait for CLOCK (inverted) ... 
    beq    _write1             ; ... to go low
    ; Write the data
    rol    GP0                 ; Get the next bit ...
    rol    a                   ; ... to A bit 0
    and    #1                  ; Isolate the bit
    sta    APU_JOYPAD1         ; Write the bit
    ; Wait for clock to go high
_write3:
    lda    APU_JOYPAD1         ; Read controller port
    and    #0b0000_1000        ; Wait for CLOCK (inverted) ...
    bne    _write3              ; ... to go high
    ; Repeat
    dex                        ; Do all ...
    bne    _write_all          ; ... 8 bits
    rts                        ; Done

greeting:
. byte "LOWER BANK: ??  UPPER BANK: ??                                  4016: ?? 4017: ??",0

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

.include ascii_obj.asm
.include NMI_impl.asm
.include MEM_impl.asm
.include NES_impl.asm

0xFF50:
.include RESET_impl.asm
.include MMC1_impl.asm

0xFFFA:
. word NMI
. word RESET
. word IRQ