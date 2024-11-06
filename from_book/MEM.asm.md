
```code
#macro write_word(value,address)
#   lda #:value:&0xFF
#   sta :address:
#   lda #:value:>>8
#   sta :address:+1
```