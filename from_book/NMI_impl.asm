NMI:

  pha                        ; Save ...
  txa                        ; ...
  pha                        ; ...
  tya                        ; ...
  pha                        ; ... registers

  lda    nmi_ready           ; 0 means ...
  beq    _ppu_update_end     ; ... skip NMI completely

  cmp    #1                  ; 1 means ...
  beq    _do_rendering       ; ... render the screen

; 2 means disable rendering

  lda    #0                  ; Disable all ...
  sta    PPUMASK             ; ... screen rendering 
  sta    nmi_ready           ; Skip NMIs until re-enabled
  jmp    _ppu_update_end     ; Done

_do_rendering:

; Copy our OAM data to the PPU

  ldx    #0                  ; Address 0x0000 ...
  stx    OAMADDR             ; ... in sprite ram
  lda    #oam >> 8           ; MSB of ...
  sta    APU_OAMDMA          ; ... our OAM data

; Copy our palette to the PPU

  lda    #0b10001000         ; Set the name table ...
  sta    PPUCTRL             ; ... use (?? this never changes)
  lda    PPUSTATUS           ; Clear vblank flag
  lda    #0x3F               ; Set VRAM address ...
  sta    PPUADDR             ; ... to ...
  stx    PPUADDR             ; ... 0x3F00
  ldx    #0                  ; Start at index 0
_loop:
  lda    palette,X           ; From the palette ...
  sta    PPUDATA             ; ... to VRAM
  inx                        ; Bump our index
  cpx    #32                 ; All done?
  bcc    _loop               ; No, keep going

  lda    #0b10001000         ; Set the name table ...
  sta    PPUCTRL             ; ... use (?? this never changes)
  lda    #0x00               
  sta    PPUSCROLL
  sta    PPUSCROLL

  lda    #0b00011110         ; Enable ...
  sta    PPUMASK             ; ... rendering (we might have turned it off with =2)

  ldx    #0                  ; Skip NMI from ...
  stx    nmi_ready           ; ... now on

_ppu_update_end:
  pla                        ; Restore ...
  tay                        ; ...
  pla                        ; ...
  tax                        ; ...
  pla                        ; ... registers
  rti                        ; Return from NMI

IRQ:
  rti

; Some helper functions

wait_ppu_update:
  lda    #1                 ; Enable ...
  sta    nmi_ready          ; ... rendering
_loop:
  lda    nmi_ready          ; Wait for ...
  bne    _loop              ; ... rendering to finish
  rts                       ; Done

wait_ppu_off:
  lda    #1                 ; Disable ...
  sta    nmi_ready          ; ... rendering
_loop:
  lda    nmi_ready          ; Wait for ...
  bne    _loop              ; ... ack from NMI handler
  rts                       ; Done