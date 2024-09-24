; Cartridge and console hardware
.include cart_zelda_kid.asm 
.include nes.asm            

; functions in the upper bank
.include serial_B7.asm.lab.asm

; RAM use (shared among banks)
.include serial_ram.asm

0x8000:
    .byte 0x00

0xBF50:
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
0xBFFA:
    .word 0xFF50   ; In case this bank is mapped to upper ROM at RESET
    .word 0xFF50   ; RESET to top
    .word 0xFF50   ; IRQ/BRK to top