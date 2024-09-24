
; Info about the external cartridge hardware
.include cart_zelda_kid.asm

; Info about the internal NES console hardware
.include nes.asm

0xC000:

.include ascii.asm

0xFFFA:
    .word 0xC000 ; NMI to top
    .word 0xC000 ; RESET to top
    .word 0xC000 ; IRQ/BRK to top