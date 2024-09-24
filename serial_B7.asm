
; Cartridge and console hardware
.include cart_zelda_kid.asm 
.include nes.asm           

; RAM use (shared among banks)
.include serial_ram.asm

0xC000:

START:
    JMP START

NMI:
; Called at the end of each video frame (at the start of VBLANK)
    PHA                   ; Hold A
    LDA   frame_counter   ; Bump ...
    CLC                   ; ...
    ADC   #1              ; ...
    STA   frame_counter   ; ... the frame counter
    PLA                   ; Restore A
    RTI                   ; Done

; Pull in library routines
.include nes_obj.asm
.include mapper_mmc1_obj.asm

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