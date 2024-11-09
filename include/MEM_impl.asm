
; Copy a block of memory of size SIZE from SOURCE to DESTINATION
; SOURCE = GP0,GP0+1
; DESTINATION = GP1,GP1+1
; SIZE = GP2,GP2+1
MEM_copy_large_block:
    ldy    #0
_loop:
    lda    (GP0),Y
    sta    (GP1),Y
;
    lda    GP0
    clc
    adc    #1
    sta    GP0
    lda    GP0+1
    adc    #0
    sta    GP0+1
;
    lda    GP1
    clc
    adc    #1
    sta    GP1
    lda    GP1+1
    adc    #0
    sta    GP1+1
;
    lda    GP2
    sec
    sbc    #1
    sta    GP2
    lda    GP2+1
    sbc    #0
    sta    GP2+1
;
    lda    GP2
    bne    _loop
    lda    GP2+1
    bne    _loop
    rts