
with open('Zelda.nes','rb') as f:
    rom = f.read()

    with open('zelda.bin', 'wb') as g:
        g.write(rom[16:])

    