.CPU 6502

.include NES.asm.md
.include MMC1.asm.md
0x8000:

. byte 0x25  ; Bank identifier for reset experiment

START:
    jmp START
NMI:
    rti
IRQ:
    rti

0xBF50:
.include RESET_impl.asm
.include MMC1_impl.asm

0xBFFA:
. word NMI
. word RESET
. word IRQ