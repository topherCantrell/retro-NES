py -m opcodetools.asm bitbang.asm -o _b0.bin -l bitbang.lst -d VALUE=0x18
py -m opcodetools.asm bitbang.asm -o _b1.bin -d VALUE=0x29
py -m opcodetools.asm bitbang.asm -o _b2.bin -d VALUE=0x3F
py -m opcodetools.asm bitbang.asm -o _b3.bin -d VALUE=0x4E
py -m opcodetools.asm bitbang.asm -o _b4.bin -d VALUE=0x5D
py -m opcodetools.asm bitbang.asm -o _b5.bin -d VALUE=0x6C
py -m opcodetools.asm bitbang.asm -o _b6.bin -d VALUE=0x7B
py -m opcodetools.asm bitbang.asm -o _b7.bin -d VALUE=0x8A

py ../../nes_file.py bitbang.nes _b0.bin _b1.bin _b2.bin _b3.bin _b4.bin _b5.bin _b6.bin _b7.bin
