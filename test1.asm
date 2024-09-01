; Info about the cartridge hardware
.include cart_zelda_kid.asm

; Info about the NES console hardware
.include nes.asm

; From ZELDA
0xF800:
; Code lifted from Zelda
    SEI                           ; Disable most interrupts (can't disable NMI)
    CLD                           ; Clear decimal flag
    LDA     #0x00                 ; Turn off ...
    STA     PPU_control_1         ; ... the source of NMIs
    LDX     #0xFF                 ; Set stack to ...
    TXS                           ; ... 01FF
_wait1:
    LDA     PPU_status            ; Wait ...
    AND     #0x80                 ; ... for ...
    BEQ     _wait1                ; ... VBLANK
_wait2:
    LDA     PPU_status            ; Wait ...
    AND     #0x80                 ; ... for another ...
    BEQ     _wait2                ; ... VBLANK (1st might have been a leftover flag)
    JSR     MMC_reset             ; Reset the MMC1 to a known state        
    LDA     #0x0F                 ; Set MMC control to 8K CHR ROM, fixed/bank 16K PRG pages, ...
    JSR     MMC_set_control       ; ... and horizontal mirroring (vertical scrolling)
    LDA     #0x00                 ; Set MMC reg1 VROM bank
    JSR     MMC_set_chr_bank_0    ; Clear the VROM bank (we have RAM with no swapping)
; Zelda does this. We will too.
    LDA     #0x07                 ; Interesting! Put bank 7 ...
    JSR     MMC_set_prg_bank      ; ... in the low ROM bank

done:
; Code goes here
    JMP     done

; Now pull in the routines
.include mapper_mmc1_obj.asm

0xFFFA:
    .word 0xF800 ; NMI to top
    .word 0xF800 ; RESET to top
    .word 0xF800 ; IRQ/BRK to top
