.include_defines cart_zelda_kid.asm    ; Info about the cartridge hardware
.include_defines hardware.asm          ; Info about the NES console hardware

; From ZELDA
0xF800:
; Code lifted from Zelda
    SEI                         ; Disable most interrupts (can't disable NMI)
    CLD                         ; Clear decimal flag
    LDA     #$00                ; Clear the PPU control register ...
    STA     PPU_control_1       ; ... truns off NMIs
    LDX     #$FF                ; Set stack to ...
    TXS                         ; ... 01FF
wait1:
    LDA     PPU_status          ; Wait ...
    AND     #$80                ; ... for ...
    BEQ     wait1               ; ... VBLANK
wait2:
    LDA     PPU_status          ; Wait ...
    AND     #$80                ; ... for another ...
    BEQ     wait2               ; ... VBLANK (1st might have been a leftover flag)
    JSR     reset_mmc           ; Reset the MMC1 to a known state        
    LDA     #$0F                ; Set MMC control to 8K CHR ROM, fixed/bank 16K PRG pages, ...
    JSR     set_mmc_control     ; ... and horizontal mirroring (vertical scrolling)
    LDA     #$00                ; Set MMC reg1 VROM bank
    JSR     set_chr_bank_0      ; Clear the VROM bank (we have RAM with no swapping)
; Zelda does this. We will too.
    LDA     #$07                ; Interesting! Put bank 7 ...
    JSR     set_mmc_bank        ; ... in the low ROM bank

done:
; Code goes here
    JMP     done

; Now pull in the routines
.include_code cart_zelda_kid.asm

0xFFFA:
    . 0x00, 0xF8 ; NMI to F800
    . 0x00, 0xF8 ; RESET to F800
    . 0x00, 0xF8 ; IRQ to F800
