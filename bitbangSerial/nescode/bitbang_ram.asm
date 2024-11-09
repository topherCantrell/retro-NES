.GP0      = 0x00               ; General purpose register 0
.GP1      = 0x02               ; General purpose register 1
.GP2      = 0x04               ; General purpose register 2

.nmi_ready = 0x10              ; 0=skip NMI, 1=render, 2=disable rendering and NMI

; Stack is 0x0100-0x01FF

.oam       = 0x200             ; 256 bytes (32 sprites, 4 bytes each)
.palette   = 0x300             ; 32 bytes