
; Cartridge and console hardware
.include ../include/cart_zelda_kid.asm.md
.include ../include/nes.asm.md           

; RAM use (shared among banks)
.include serial_ram.asm

0xC000:
    .byte 0xC7
 
VRAM_INITS:
; Tile data
. word ch20_2F_Patterns  ; Spaces and digits
. word 0x20*16           ; PPU memory ascii space
. word ch5B_60_Patterns - ch20_2F_Patterns   ; 14 characters, 16 bytes each
;
; Color palette
. word PaletteData
. word 0x3F00
. word 32
;
; Name table
. word NameTableData
. word 0x2000
. word 32*30
;
. word 0             ; End of list

greeting:
. byte "LOWER BANK: ??  UPPER BANK: ??                                  4016: ?? 4017: ??",0

START:

; DMA the sprite data
    ldx    #0
    stx    PPU_sprite_address
    lda    #OAMData >> 8
    sta    APU_spr_ram_dma

; VRAM initialization
    lda    #VRAM_INITS & 0xFF
    sta    GP_06
    lda    #VRAM_INITS >> 8
    sta    GP_06+1
    jsr    CopyMultiBlocksToVRAM

; Print static
    lda    #greeting & 0xFF
    sta    GP_00
    lda    #greeting >> 8
    sta    GP_00+1
    ;
    lda    #0x2040 & 0xFF
    sta    GP_02
    lda    #0x2040 >> 8
    sta    GP_02+1
    jsr    printString

    lda    #0x204C & 0xFF
    sta    GP_02
    lda    #0x204C >> 8
    sta    GP_02+1
    lda    0x80
    jsr    printHexByte

    lda    #0x204C & 0xFF
    sta    GP_02
    lda    #0x204C >> 8
    sta    GP_02+1
    lda    0x80
    jsr    printHexByte

    lda    #0x205C & 0xFF
    sta    GP_02
    lda    #0x205C >> 8
    sta    GP_02+1
    lda    0x81
    jsr    printHexByte

    jsr    EnableVideo

_wait1:
    lda     #0
    sta     PPU_scroll_offset
    lda     #0
    sta     PPU_scroll_offset 
    LDA     PPU_status          ; Wait ...
    AND     #0x80               ; ... for ...
    BEQ     _wait1              ; ... VBLANK
    
    lda    #0x2086 & 0xFF
    sta    GP_02
    lda    #0x2086 >> 8
    sta    GP_02+1
    lda    0x4016
    and    #0x1F
    jsr    printHexByte

    lda    #0x208F & 0xFF
    sta    GP_02
    lda    #0x208F >> 8
    sta    GP_02+1
    lda    0x4017
    and    #0x1F
    jsr    printHexByte

    lda    0x4016
    and    #1
    sta    0x4016
    
_loop:
    jmp    _wait1

EnableVideo:
; Turn on video TODO move to library
    lda    PPU_status
    lda    #0b00011110
    sta    PPU_mask
    rts

DisableVideo:
; Turn off all video TODO move to library
    lda     #0x00               ; Clear the PPU control register ...
    sta     PPU_mask            ; ... truns off NMI source
    rts                         ; Done

NMI:
; Called at the end of each video frame (at the start of VBLANK)
    pha                   ; Hold A
    lda   frame_counter   ; Bump ...
    clc                   ; ...
    adc   #1              ; ...
    sta   frame_counter   ; ... the frame counter
    pla                   ; Restore A
    rti                   ; Done

PaletteData:
. byte 0x0F, 0x15, 0x26, 0x37
. byte 0x0F, 0x09, 0x19, 0x29
. byte 0x0F, 0x01, 0x11, 0x21
. byte 0x0F, 0x00, 0x10, 0x30
. byte 0x0F, 0x18, 0x28, 0x38
. byte 0x0F, 0x14, 0x24, 0x34
. byte 0x0F, 0x1B, 0x2B, 0x3B
. byte 0x0F, 0x12, 0x22, 0x32

NameTableData:
. byte "A","@",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"@","B"
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
. byte "C","@",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"@","D"


; Text characters
.include ../include/ascii_obj.asm

.include ../include/vram_init_obj.asm

; Pull in library routines
.include ../include/nes_obj.asm
.include ../include/mapper_mmc1_obj.asm

; Sprites
0xFE00:
OAMData:
. byte 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0, 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0
. byte 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0, 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0
. byte 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0, 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0
. byte 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0, 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0
. byte 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0, 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0
. byte 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0, 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0
. byte 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0, 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0
. byte 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0, 0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0 ,0xFF,0,0,0


0xFF50:
;
; At power on, the MMC1 is in a random state. Any of the program banks could be mapped
; to the upper part of ROM. Thus every bank has this exact same reset code at the end of the
; bank. No matter which bank is loaded, the reset code moves bank 7 into the upper part 
; of ROM. Since all the banks have this same code at the same address, the startup routine 
; continues at the next instruction (but in the bank 7) after the bank swap.
;
; The real NMI handler lives in bank 7. The reset code quickly turns NMIs off, but just
; in case an NMI should sneak in before bank 7 is in place, the other banks point the NMI
; to the reset code. The reset code is quick -- that "sneak in" would only happen once.
; 
.include serial_reset.asm
;
0xFFFA:
    .word NMI    ; NMI handler
    .word 0xFF50 ; RESET to top
    .word 0xFF50 ; IRQ/BRK to top