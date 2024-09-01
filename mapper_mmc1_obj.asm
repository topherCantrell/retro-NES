.CPU 6502

; .include mapper_mmc1.asm

MMC_set_control:
; Code lifted from Zelda
    STA     MMC_Control         ; MMC Register 0 (control): --edcba ...
    LSR     A                   ; ... mirroring
    STA     MMC_Control         ; ... mirroring
    LSR     A                   ; ... switch: c=0 high ROM, C=1 low ROM
    STA     MMC_Control         ; ... size: d=0 32K (full), D=1 16K (half)
    LSR     A                   ; ... chrrom mode: e=0 8K banks, B=1 4K banks
    STA     MMC_Control         ; The MMC is write-trigger (write to ROM ...
    LSR     A                   ; .. has no affect anyway).
    STA     MMC_Control         ; Bits are written from LSB to MSB ...
    RTS                         ; ... only 5 bits

MMC_set_chr_bank_0:
    STA     MMC_CHR_Bank0       ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank0       ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank0       ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank0       ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank0       ; 
    RTS                         ; 

MMC_set_chr_bank_1:
    STA     MMC_CHR_Bank1       ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank1       ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank1       ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank1       ; 
    LSR     A                   ; 
    STA     MMC_CHR_Bank1       ; 
    RTS                         ; 

MMC_set_prg_bank: 
; Set the MMC Bank register (3) to value in A
; Code lifted from Zelda
    STA     MMC_PRG_Bank        ; MMC Register 3 (ROM page switching): --edcba ...
    LSR     A                   ; ...
    STA     MMC_PRG_Bank        ; ... Write the ...
    LSR     A                   ; ... switching ...
    STA     MMC_PRG_Bank        ; ... page ...
    LSR     A                   ; ... number
    STA     MMC_PRG_Bank        ; The MMC is write-trigger (write to ROM ...
    LSR     A                   ; .. has no affect anyway).
    STA     MMC_PRG_Bank        ; Bits are written from LSB to MSB ...
    RTS                         ; ... only 5 bits

MMC_reset:
; Code lifted from Zelda
    ORA     #0xFF               ; Reset ...
    STA     MMC_Control         ; ... MMC1
; One RESET gets all the registers. Other documents think that development hardware might
; have needed RESET on all four. So here it is.
    STA     MMC_CHR_Bank0       ; All ...
    STA     MMC_CHR_Bank1       ; ... four ...
    STA     MMC_PRG_Bank        ; ... MMC1 registers
    RTS
