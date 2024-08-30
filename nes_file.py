
# fname = 'KidIcarus.nes'
fname = 'Zelda.nes'

# Both have 128K ROM. The difference is battery-backed RAM (Zelda has it, Kid Icarus doesn't)
CART_ZELDA_HEADER = [78, 69, 83, 26, 8, 0, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0]
CART_KID_HEADER = [78, 69, 83, 26, 8, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0]

class NESFile:

    @staticmethod
    def make_new_zelda_cart(fname):
        with open(fname, 'wb') as rom:
            rom.write(bytes(CART_ZELDA_HEADER))
            rom.write(b'\xFF' * 128 * 1024)
        return NESFile(fname)
    
    @staticmethod
    def make_new_kid_cart(fname):
        with open(fname, 'wb') as rom:
            rom.write(bytes(CART_KID_HEADER))
            rom.write(b'\xFF' * 128 * 1024)
        return NESFile(fname)

    def __init__(self, fname):
        self.fname = fname
        with open(fname, 'rb') as rom:
            self.header = rom.read(16)
            header = list(self.header)
            self.hdr_magic = header[:4]
            self.hdr_prg_size = header[4]            
            self.hdr_chr_size = header[5]
            self.hdr_flags6 = header[6]
            self.hdr_vertical_arrangement = bool(header[6] & 0x01)
            self.hdr_battery_backed = bool(header[6] & 0x02)
            self.hdr_trainer_present = bool(header[6] & 0x04)
            self.hdr_four_screen_vram = bool(header[6] & 0x08)
            self.hdr_mapper = (header[6] & 0xF0) >> 4
            self.hdr_flags7 = header[7]
            self.hdr_prg_ram_size = header[8]
            self.hdr_is_pal = bool(header[9] & 0x01)
            self.hdr_flags10 = header[10]
            self.hdr_padding = header[11:]

            print(f"Cart ROM size (in 16K blocks): {self.hdr_prg_size}")
            print(f"Cart CHR ROM size (in 8K blocks): {self.hdr_chr_size}")
            print(f"Cart RAM size (in 8K blocks): {self.hdr_prg_ram_size}")
            print(f"Vertical arrangement: {self.hdr_vertical_arrangement}")
            print(f"Battery backed: {self.hdr_battery_backed}")
            print(f"Trainer present: {self.hdr_trainer_present}")
            print(f"Four screen VRAM: {self.hdr_four_screen_vram}")
            print(f"Mapper: {self.hdr_mapper}")
            print(f"flags7: {self.hdr_flags7}")
            print(f"Is PAL: {self.hdr_is_pal}")
            print(f"flags10: {self.hdr_flags10}")

            self.bindata = list(rom.read())

    def read_from_bank(self, bank, start, num_bytes):
        pos = 0x4000 * bank + start
        return self.bindata[pos:pos + num_bytes]

    def write_to_bank(self, bank, data, start):
        pos = 0x4000 * bank + start
        for d in data:
            self.bindata[pos] = d
            pos += 1

    def save(self):
        with open(self.fname, 'wb') as rom:
            rom.write(self.header)
            rom.write(bytes(self.bindata))        

if __name__ == '__main__':
    nes = NESFile(fname)

    print(nes.read_from_bank(7, 0, 16))
