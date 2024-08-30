; MMC1 Memory Mapper Hardware (Zelda, Kid Icarrus, others)

; https://www.nesdev.org/wiki/MMC1

; Write 1xxxxxxx to any address 8000-FFFF to reset the MMC1

; Write 5 times to address to shift value into the register

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

.MMC_Control   = 0x8000
.MMC_CHR_Bank0 = 0xA000
.MMC_CHR_Bank1 = 0xC000
.MMC_PRG_Bank  = 0xE000

set_mmc_control:
; Code lifted from Zelda
    STA     MMC_Control               ; MMC Register 0 (control): --edcba ...
    LSR     A                   ; ... mirroring
    STA     MMC_Control               ; ... mirroring
    LSR     A                   ; ... switch: c=0 high ROM, C=1 low ROM
    STA     MMC_Control               ; ... size: d=0 32K (full), D=1 16K (half)
    LSR     A                   ; ... chrrom mode: e=0 8K banks, B=1 4K banks
    STA     MMC_Control               ; The MMC is write-trigger (write to ROM ...
    LSR     A                   ; .. has no affect anyway).
    STA     MMC_Control               ; Bits are written from LSB to MSB ...
    RTS                         ; ... only 5 bits

set_chr_bank_0:
    STA     MMC_CHR_Bank0               ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank0               ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank0               ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank0               ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank0               ; 
    RTS                         ; 

set_chr_bank_1:
    STA     MMC_CHR_Bank1               ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank1               ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank1               ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank1               ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank1               ; 
    RTS                         ; 

set_mmc_bank: 
; Set the MMC Bank register (3) to value in A
; Code lifted from Zelda
    STA     MMC_PRG_Bank               ; MMC Register 3 (ROM page switching): --edcba ...
    LSR     A                   ; ...
    STA     MMC_PRG_Bank               ; ... Write the ...
    LSR     A                   ; ... switching ...
    STA     MMC_PRG_Bank               ; ... page ...
    LSR     A                   ; ... number
    STA     MMC_PRG_Bank               ; The MMC is write-trigger (write to ROM ...
    LSR     A                   ; .. has no affect anyway).
    STA     MMC_PRG_Bank               ; Bits are written from LSB to MSB ...
    RTS                         ; ... only 5 bits

reset_mmc:
; Code lifted from Zelda
    ORA     #$FF                ; Reset ...
    STA     MMC_Control               ; ... MMC1
; One RESET gets all the registers. Other documents think that development hardware might
; have needed RESET on all four. So here it is.
    STA     MMC_CHR_Bank0               ; All ...
    STA     MMC_CHR_Bank1               ; ... four ...
    STA     MMC_PRG_Bank               ; ... MMC1 registers
    RTS