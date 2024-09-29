py -m opcodetools.asm serial_B7.asm

py -m opcodetools.asm serial_B0.asm
py -m opcodetools.asm serial_B1.asm
py -m opcodetools.asm serial_B2.asm
py -m opcodetools.asm serial_B3.asm
py -m opcodetools.asm serial_B4.asm
py -m opcodetools.asm serial_B5.asm
py -m opcodetools.asm serial_B6.asm

py ../nes_file.py serial.nes serial_B0.asm.bin serial_B1.asm.bin serial_B2.asm.bin serial_B3.asm.bin serial_B4.asm.bin serial_B5.asm.bin serial_B6.asm.bin serial_B7.asm.bin
