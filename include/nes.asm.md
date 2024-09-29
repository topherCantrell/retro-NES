```code
; # Memory Buses and Memory Mappers
;
; The NES has two address/data buses, one for the CPU and one for the PPU.
; The CPU can load data into the PPU's memory through the PPU's registers.
;
; The cartridge contains address space for RAM and ROM for the CPU and PPU. 
; The cartridge supports 8K of CPU RAM mapped from 6000 to 7FFF. This is often
; battery backed for saving game data. Many cartridges do not supply this area.
;
; The cartridge supports 32K of program ROM for the CPU.
;
; The cartridge contains address space for 8K of pattern tables for the PPU.
; A few cartridges (like Zelda) map 8K RAM to this space and move tiles from
; the program ROM as needed. Other cartridges used fixed ROMs for the patterns.
;
; Most cartridges contain larger memory chips than can be directly mapped to
; these cartridge areas. Each cartridge contains a memory mapper that maps
; individual banks of the larger areas to the memory map accessible by the
; CPU and PPU.
;
; There are many different memory mappers with differing capabilities. Zelda,
; for example, uses MMC1 which allows for 256K of program ROM (as 16 16K banks) 
; and 128K of pattern tables (as 32 4K banks). But Zelda only uses 128K of
; program ROM and 8K RAM of pattern tables for the PPU.

; # CPU Memory Map
;
; 0000 - 07FF   2K Internal RAM (mirrored every 2K)
; 2000 - 2007   Internal PPU registers (with mirrors)
; 4000 - 4017   Internal APU registers
;
; 4018 - 5FFF   Cartridge expansion (nearly 8K)
; 6000 - 7FFF   8K Cartridge RAM (often battery backed)
; 8000 - FFFF   32K Cartridge ROM
;
; FFFA: NMI vector
; FFFC: RESET vector
; FFFE: IRQ/BRK vector

; # PPU Mempory Map
;
; 0000 - 0FFF   Pattern Table 0 256 tiles (4K in the cartridge)
; 1000 - 1FFF   Pattern Table 1 256 tiles (4K in the cartridge)
;
; 2000 - 23FF   Nametable 0
; 2400 - 27FF   Nametable 1
; 2800 - 2BFF   Nametable 2
; 2C00 - 2FFF   Nametable 3
; 3000 - 3EFF   Mirrors of 2000-2EFF
; 3F00 - 3F1F   Background and Sprite Palettes
; 3F20 - 3FFF   Mirrors of 3F00-3F1F

.CPU 6502

; PPU registers
.PPU_control        = 0x2000
.PPU_mask           = 0x2001
.PPU_status         = 0x2002
.PPU_sprite_address = 0x2003
.PPU_sprite_data    = 0x2004
.PPU_scroll_offset  = 0x2005
.PPU_vram_address   = 0x2006
.PPU_vram_data      = 0x2007

; APU registers
.APU_channel_1_volume         = 0x4000
.APU_channel_1_sweep          = 0x4001
.APU_channel_1_frequency      = 0x4002
.APU_channel_1_length         = 0x4003
.APU_channel_2_volume         = 0x4004
.APU_channel_2_sweep          = 0x4005
.APU_channel_2_frequency      = 0x4006
.APU_channel_2_length         = 0x4007
.APU_channel_3_linear_counter = 0x4008
; APU_channel_3_unused        = 0x4009
.APU_channel_3_frequency      = 0x400A
.APU_channel_3_length         = 0x400B
.APU_channel_4_volume         = 0x400C
; APU_channel_4_unused        = 0x400D
.APU_channel_4_frequency      = 0x400E
.APU_channel_4_length         = 0x400F
.APU_dm_control               = 0x4010
.APU_channel_5_delta_counter  = 0x4011
.APU_channel_5_address        = 0x4012
.APU_channel_5_length         = 0x4013
.APU_spr_ram_dma              = 0x4014
.APU_status                   = 0x4015
.APU_joypad_1                 = 0x4016
.APU_joypad_2                 = 0x4017
```
