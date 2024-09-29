CopyMultiBlocksToVRAM:
; Copy multiple blocks of data from ROM to VRAM through the PPU registers.
; GP06 = Pointer to 6-byte structures (2nd byte 0 for end of list)
;
    ldy     #0x00                ; start with 1st record
_copyLoop:
    lda     (GP_06),Y            ; Read ROM address MSB    
    sta     GP_00                ; Save ROM address MSB
    iny                          ; Next byte
    lda     (GP_06),Y            ; Read ROM address LSB
    sta     GP_00+1              ; Save ROM address LSB
    ora     GP_00                ; Address is 0?
    beq     _done                ; Yes ... end of list ... done
    iny                          ; Next byte
    lda     (GP_06),Y            ; Read VRAM address MSB
    sta     GP_02                ; Save VRAM address MSB
    iny                          ; Next byte
    lda     (GP_06),Y            ; Read VRAM address LSB
    sta     GP_02+1              ; Save VRAM address LSB
    iny                          ; Next byte
    lda     (GP_06),Y            ; Read length MSB
    sta     GP_04                ; Save length MSB
    iny                          ; Next byte
    lda     (GP_06),Y            ; Read length LSB
    sta     GP_04+1              ; Save length LSB
    iny                          ; Next byte
    tya                          ; Save ...
    pha                          ; ... Y
    jsr     CopyBlockToVRAM      ; Copy the block
    pla                          ; Restore ...
    tay                          ; ... Y
    jmp     _copyLoop            ; Next block
_done:
    rts

CopyBlockToVRAM:
; Copy a block of data from ROM to VRAM through the PPU registers.
;
; GP_00 = ROM address
; GP_02 = VRAM address
; GP_04 = Length of data to copy
;
    lda     PPU_status           ; Clear address vram address latch
;
    lda     GP_02+1              ; VRAM ...
    sta     PPU_vram_address     ; ... MSB
    lda     GP_02                ; VRAM ...
    sta     PPU_vram_address     ; ... LSB
;
    ldy     #0x00                ; 0 offset in next read
_copyLoop:
    lda     (GP_00),Y            ; Read byte from ROM
    sta     PPU_vram_data        ; Write byte to VRAM
;
    lda     GP_00                ; Increment ...
    clc                          ; ... two ...
    adc     #0x01                ; ... byte ...
    sta     GP_00                ; ... pointer ...
    lda     GP_00+1              ; ... at ...
    adc     #0x00                ; ... 00 and ...
    sta     GP_00+1                ; ... 01
    ;
    lda     GP_04                ; Decrement ...
    sec                          ; ... two ...
    sbc     #0x01                ; ... byte ...
    sta     GP_04                ; ... count ...
    lda     GP_04+1              ; ... at ...
    sbc     #0x00                ; ... 02 and ...
    sta     GP_04+1              ; ... 03
    ;
    lda     GP_04                ; More to do?
    bne     _copyLoop            ; Yes ... go move all
    lda     GP_04+1              ; More to do?
    bne     _copyLoop            ; Yes ... go move all
    rts
