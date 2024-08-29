; MMC1 Memory Mapper Hardware (Zelda, Kid Icarrus, others)

; https://www.nesdev.org/wiki/MMC1

; Write 1xxxxxxx to any address 8000-FFFF to reset the MMC1

; Write 5 times to address to shift value into the register

; Kid Icarus: 128K PRG / 0K CHR (MMC1) Vertical mirroring
; Zelda:      128K PRG / 0K CHR (MMC1) Horizontal mirroring

; 1_00_xxxxxxxxxxxxx CONTROL:
; CPPMM
;  - MM = Mirroring
;    - 00: one screen, lower bank
;    - 01: one screen, upper bank
;    - 10: vertical
;    - 11: horizontal
;  - PP = Program ROM bank mode
;    - 00: switch 32 KB at 8000, ignore low bit of bank number
;    - 01: (same as 00)
;    - 02: Fix first bank at 8000, switch 16K bank at C000
;    - 03: Fix last bank at C000, switch 16K bank at 8000 (reset value)
; - C = CHR ROM bank mode
;    - 0: switch 8K at a time
;    - 1: switch two separate 4K banks

; 1_01_xxxxxxxxxxxxx CHR BANK 0
; CCCCC = Select 4K CHR bank at PPU 0000 (ignored in 8K mode)

; 1_10_xxxxxxxxxxxxx CHR BANK 1
; CCCCC = Select 4K CHR bank at PPU 1000 (ignored in 8K mode)

; 1_11_xxxxxxxxxxxxx PRG BANK
; RPPPP
; PPPP = Select 16K ROM bank (lower bit ignored in 32K mode)
; R = unused in MMC1

; TODO example code here
