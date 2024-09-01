; Defines for the NES hardware

.CPU 6502

; 0000 - 07FF   2K Internal RAM
; 0800 - 1FFF   (unused -- mirrors)
; 2000 - 4FFF   Memory Mapped  Registers
; 5000 - 5FFF   Expansion modules (keyboards, etc.)
; 6000 - 7FFF   8K Cartridge RAM (WRAM)
; 8000 - FFFF   32K Cartridge ROM

; 6502 hardware vectors
; FFFA: NMI
; FFFC: RESET
; FFFE: IRQ/BRK

; PPU registers
.PPU_control_1 = 0x2000
.PPU_status = 0x2002
