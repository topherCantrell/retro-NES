py -m opcodetools.asm serial.asm -o _b0.bin -l serial.lst
py -m opcodetools.asm serial.asm -o _b1.bin
py -m opcodetools.asm serial.asm -o _b2.bin
py -m opcodetools.asm serial.asm -o _b3.bin
py -m opcodetools.asm serial.asm -o _b4.bin
py -m opcodetools.asm serial.asm -o _b5.bin
py -m opcodetools.asm serial.asm -o _b6.bin
py -m opcodetools.asm serial.asm -o _b7.bin 

py ../../nes_file.py serial.nes _b0.bin _b1.bin _b2.bin _b3.bin _b4.bin _b5.bin _b6.bin _b7.bin
