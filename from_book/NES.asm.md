# Memory Buses and Memory Mappers

The NES has three address/data buses: sprite memory, PPU memory, and CPU memory.

The 256 bytes of sprite memory is write-only. The CPU can write data to the sprite
memory through two PPU registers. There is also a DMA channel to move data from
CPU memory to the sprite ram. The CPU sets up the DMA and lets it run in the background.

The PPU memory holds the bit patterns, name tables, and attributes for graphics.
The picture-procesing-unit (PPU) reads the data from this memory to generate
the display.

The CPU can read and write data from/to the PPU memory through two PPU
registers. These updates should be done during Verticl Blanking.

The cartridge contains address space for both the CPU memory and the PPU memory.

The cartridge contains address space for 8K of pattern tables for the PPU.
A few cartridges (like Zelda) map 8K RAM to this space and move tiles from
the program ROM as needed. Other cartridges used fixed ROMs for the patterns.

The cartridge can supply 8K of RAM memory to the CPU. This is often battery-backed
for saving game data. Many cartridges do not supply this area.

The cartridge can supply 32K of program ROM for the CPU.

Most cartridges contain larger memory chips than can be directly mapped to
these cartridge areas. Each cartridge contains a memory mapper that maps
individual banks of the larger areas to the memory map accessible by the
CPU and PPU.

There are many different memory mappers with differing capabilities. Zelda,
for example, uses MMC1 which allows for 256K of program ROM (as 16 16K banks) 
and 128K of pattern tables (as 32 4K banks). But Zelda only uses 128K of
program CPU ROM. The PPU memory space is 8K RAM of pattern tables for the PPU.
The Zelda code copies patterns from CPU ROM to PPU RAM as needed.

# CPU Memory Map

```
0000 - 07FF   2K Internal RAM (mirrored every 2K)
2000 - 2007   Internal PPU registers (with mirrors)
4000 - 4017   Internal APU registers

4018 - 5FFF   Cartridge expansion (nearly 8K)
6000 - 7FFF   8K Cartridge RAM (often battery backed)
8000 - FFFF   32K Cartridge ROM

FFFA: NMI vector
FFFC: RESET vector
FFFE: IRQ/BRK vector
```

# PPU Mempory Map

```
0000 - 0FFF   Pattern Table 0 256 tiles (4K in the cartridge)
1000 - 1FFF   Pattern Table 1 256 tiles (4K in the cartridge)

2000 - 23FF   Nametable 0 (usually mapped to PPU 2K ram)
2400 - 27FF   Nametable 1 (usually mapped to PPU 2K ram)
2800 - 2BFF   Nametable 2 (optionally supplied by cartridge)
2C00 - 2FFF   Nametable 3 (optionally supplied by cartridge)

3000 - 3EFF   Mirrors of 2000-2EFF (not used)

3F00 - 3F1F   Background and Sprite Palettes
3F20 - 3FFF   Mirrors of 3F00-3F1F
```

```code
.CPU 6502

; PPU registers
.PPUCTRL        = 0x2000 ; Write only
; https://www.nesdev.org/wiki/PPU_registers#PPUCTRL
;      VPHBSINN
;        V=1 enable NMI generation, 0 disabled
;        P=1 PPU is master, 0 read backdrop from EXT pins
;        H=1 sprites are 8x16, 0 for 8x8
;        B=0 background pattern table is 0000, 1 for 1000
;        S=0 sprite pattern table for 8x8 is 0000, 1 for 1000 (ignored in 8x16)
;        I=0 vram increments by 1 with each write, 0 for increment by 32 for each write
;        NN base name table address: 0=2000, 1=2400, 2=2800, 3=2C00

.PPUMASK           = 0x2001 ; Write only
; https://www.nesdev.org/wiki/PPU_registers#PPUMASK
;      BGRsbMmG
;        BGR Emphasize Blue, Green, and Red
;        s=1 enable sprite rendering, 0 for hide
;        b=1 enable background rendering, 0 for hide
;        M=1 show sprites in leftmost 8 pixels, 0 for hide
;        m=1 show background leftmost 8 pixels, 0 for hide
;        G=0 normal color, 1 for greyscale

.PPUSTATUS         = 0x2002 ; Read only
; https://www.nesdev.org/wiki/PPU_registers#PPUSTATUS
;      VSO-----
;        V=1 VBlank happened, cleared on read, unreliable (use NMI)
;        S=1 sprite 0 hit the background
;        O=1 when more than 8 sprites are on a line (buggy and not reliable)

; https://www.nesdev.org/wiki/PPU_registers#OAMADDR
.OAMADDR = 0x2003 ; Write 0 here and use DMA
.OAMDATA = 0x2004 ; Use DMA instead

; IMPORTANT: writes to PPU_vram_address and name-table-bits in PPU_control must
; happen BEFORE writes to the scroll offset.
; https://www.nesdev.org/wiki/PPU_registers#PPUSCROLL

.PPUSCROLL  = 0x2005 ; 1st write (after reading the status) for X scroll, 2nd write for Y
;https://www.nesdev.org/wiki/PPU_registers#PPUSCROLL

; https://www.nesdev.org/wiki/PPU_registers#PPUADDR
.PPUADDR   = 0x2006 ; 1st write (after reading the status) for MSB, 2nd for LSB
.PPUDATA   = 0x2007
;
; The PPU palette can become corrupted (see the link). When done writing to palette memory, 
; the workaround is to always:
;   1. Update the address, if necessary, so that it's pointing at $3F00, $3F10, $3F20, or any other mirror.
;   2. Only then change the address to point outside of palette memory.

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

.APU_DM_CONTROL               = 0x4010
;      IL--RRRR
;        I=1 enable DPCM interrupt, 0 for diable
;        L loop flag
;        RRRR Rate index

.APU_channel_5_delta_counter  = 0x4011
.APU_channel_5_address        = 0x4012
.APU_channel_5_length         = 0x4013
.APU_OAMDMA                   = 0x4014
.APU_status                   = 0x4015
.APU_JOYPAD1                  = 0x4016

.APU_JOYPAD2                  = 0x4017
;      MI------
;        M=1 5-step sequence, 0 for 4-step sequence
;        I=1 interrupt inhibited, 0 for enterrupt enabled

```
