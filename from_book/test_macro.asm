.CPU 6502

.include first_ram.asm
.default_palette = 0x1234

#macro write_word(value,address)
#   lda #:value:&0xFF
#   sta :address:
#   lda #:value:>>8
#   sta :address:+1

0xC000:

START:

; Clear all of RAM (including stack ... so don't make this a function)

    lda    #0                  ; RAM value (clear)    
    
; Copy default palette to our palette ram 

    #write_word(default_palette, GP0)    
    #write_word(123, GP1)

   