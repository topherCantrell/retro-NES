
with open('KidIcarus.nes','rb') as f:
    rom = f.read()

    with open('kidicarus.bin', 'wb') as g:
        g.write(rom[16:])

    