patterns = """
 ;   ..111...    0
 ;   .1..11..
 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   .11..1..
 ;   ..111...
 ;   ........
877f: 38 4C C6 C6 C6 64 38 00 00 00 00 00 00 00 00 00

 ;   ...11...    1
 ;   ..111...
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   .111111.
 ;   ........
878f: 18 38 18 18 18 18 7E 00 00 00 00 00 00 00 00 00

 ;   .11111..
 ;   11...11.
 ;   ....111.
 ;   ..1111..
 ;   .1111...
 ;   111.....
 ;   1111111.
 ;   ........
879f: 7C C6 0E 3C 78 E0 FE 00 00 00 00 00 00 00 00 00

 ;   .111111.
 ;   ....11..
 ;   ...11...
 ;   ..1111..
 ;   .....11.
 ;   11...11.
 ;   .11111..
 ;   ........
87af: 7E 0C 18 3C 06 C6 7C 00 00 00 00 00 00 00 00 00

 ;   ...111..
 ;   ..1111..
 ;   .11.11..
 ;   11..11..
 ;   1111111.
 ;   ....11..
 ;   ....11..
 ;   ........
87bf: 1C 3C 6C CC FE 0C 0C 00 00 00 00 00 00 00 00 00

 ;   111111..
 ;   11......
 ;   111111..
 ;   .....11.
 ;   .....11.
 ;   11...11.
 ;   .11111..
 ;   ........
87cf: FC C0 FC 06 06 C6 7C 00 00 00 00 00 00 00 00 00

 ;   ..1111..
 ;   .11.....
 ;   11......
 ;   111111..
 ;   11...11.
 ;   11...11.
 ;   .11111..
 ;   ........
87df: 3C 60 C0 FC C6 C6 7C 00 00 00 00 00 00 00 00 00

 ;   1111111.
 ;   11...11.
 ;   ....11..
 ;   ...11...
 ;   ..11....
 ;   ..11....
 ;   ..11....
 ;   ........
87ef: FE C6 0C 18 30 30 30 00 00 00 00 00 00 00 00 00

 ;   .1111...
 ;   11...1..
 ;   111..1..
 ;   .1111...
 ;   1....11.
 ;   1....11.
 ;   .11111..
 ;   ........
87ff: 78 C4 E4 78 86 86 7C 00 00 00 00 00 00 00 00 00

 ;   .11111..
 ;   11...11.
 ;   11...11.
 ;   .111111.
 ;   .....11.
 ;   ....11..
 ;   .1111...
 ;   ........
880f: 7C C6 C6 7E 06 0C 78 00 00 00 00 00 00 00 00 00

 ;   ..111...
 ;   .11.11..
 ;   11...11.
 ;   11...11.
 ;   1111111.
 ;   11...11.
 ;   11...11.
 ;   ........
881f: 38 6C C6 C6 FE C6 C6 00 00 00 00 00 00 00 00 00

 ;   111111..
 ;   11...11.
 ;   11...11.
 ;   111111..
 ;   11...11.
 ;   11...11.
 ;   111111..
 ;   ........
882f: FC C6 C6 FC C6 C6 FC 00 00 00 00 00 00 00 00 00

 ;   ..1111..
 ;   .11..11.
 ;   11......
 ;   11......
 ;   11......
 ;   .11..11.
 ;   ..1111..
 ;   ........
883f: 3C 66 C0 C0 C0 66 3C 00 00 00 00 00 00 00 00 00

 ;   11111...
 ;   11..11..
 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   11..11..
 ;   11111...
 ;   ........
884f: F8 CC C6 C6 C6 CC F8 00 00 00 00 00 00 00 00 00

 ;   1111111.
 ;   11......
 ;   11......
 ;   111111..
 ;   11......
 ;   11......
 ;   1111111.
 ;   ........
885f: FE C0 C0 FC C0 C0 FE 00 00 00 00 00 00 00 00 00

 ;   1111111.
 ;   11......
 ;   11......
 ;   111111..
 ;   11......
 ;   11......
 ;   11......
 ;   ........
886f: FE C0 C0 FC C0 C0 C0 00 00 00 00 00 00 00 00 00

 ;   ..11111.
 ;   .11.....
 ;   11......
 ;   11..111.
 ;   11...11.
 ;   .11..11.
 ;   ..11111.
 ;   ........
887f: 3E 60 C0 CE C6 66 3E 00 00 00 00 00 00 00 00 00

 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   1111111.
 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   ........
888f: C6 C6 C6 FE C6 C6 C6 00 00 00 00 00 00 00 00 00

 ;   ..1111..
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ..1111..
 ;   ........
889f: 3C 18 18 18 18 18 3C 00 00 00 00 00 00 00 00 00

 ;   ...1111.
 ;   .....11.
 ;   .....11.
 ;   .....11.
 ;   11...11.
 ;   11...11.
 ;   .11111..
 ;   ........
88af: 1E 06 06 06 C6 C6 7C 00 00 00 00 00 00 00 00 00

 ;   11...11.
 ;   11..11..
 ;   11.11...
 ;   1111....
 ;   11.11...
 ;   11..11..
 ;   11...11.
 ;   ........
88bf: C6 CC D8 F0 D8 CC C6 00 00 00 00 00 00 00 00 00

 ;   .11.....
 ;   .11.....
 ;   .11.....
 ;   .11.....
 ;   .11.....
 ;   .11.....
 ;   .111111.
 ;   ........
88cf: 60 60 60 60 60 60 7E 00 00 00 00 00 00 00 00 00

 ;   11...11.
 ;   111.111.
 ;   1111111.
 ;   1111111.
 ;   11.1.11.
 ;   11...11.
 ;   11...11.
 ;   ........
88df: C6 EE FE FE D6 C6 C6 00 00 00 00 00 00 00 00 00

 ;   11...11.
 ;   111..11.
 ;   1111.11.
 ;   1111111.
 ;   11.1111.
 ;   11..111.
 ;   11...11.
 ;   ........
88ef: C6 E6 F6 FE DE CE C6 00 00 00 00 00 00 00 00 00

 ;   .11111..
 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   .11111..
 ;   ........
88ff: 7C C6 C6 C6 C6 C6 7C 00 00 00 00 00 00 00 00 00

 ;   111111..
 ;   11...11.
 ;   11...11.
 ;   111111..
 ;   11......
 ;   11......
 ;   11......
 ;   ........
890f: FC C6 C6 FC C0 C0 C0 00 00 00 00 00 00 00 00 00

 ;   .11111..
 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   11.1111.
 ;   11..11..
 ;   .1111.1.
 ;   ........
891f: 7C C6 C6 C6 DE CC 7A 00 00 00 00 00 00 00 00 00

 ;   111111..
 ;   11...11.
 ;   11...11.
 ;   111111..
 ;   11.11...
 ;   11..11..
 ;   11...11.
 ;   ........
892f: FC C6 C6 FC D8 CC C6 00 00 00 00 00 00 00 00 00

 ;   .1111...
 ;   11..11..
 ;   11......
 ;   .11111..
 ;   .....11.
 ;   11...11.
 ;   .11111..
 ;   ........
893f: 78 CC C0 7C 06 C6 7C 00 00 00 00 00 00 00 00 00

 ;   .111111.
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ........
894f: 7E 18 18 18 18 18 18 00 00 00 00 00 00 00 00 00

 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   .11111..
 ;   ........
895f: C6 C6 C6 C6 C6 C6 7C 00 00 00 00 00 00 00 00 00

 ;   11...11.
 ;   11...11.
 ;   11...11.
 ;   111.111.
 ;   .11111..
 ;   ..111...
 ;   ...1....
 ;   ........
896f: C6 C6 C6 EE 7C 38 10 00 00 00 00 00 00 00 00 00

 ;   11...11.
 ;   11...11.
 ;   11.1.11.
 ;   1111111.
 ;   1111111.
 ;   111.111.
 ;   11...11.
 ;   ........
897f: C6 C6 D6 FE FE EE C6 00 00 00 00 00 00 00 00 00

 ;   11...11.
 ;   111.111.
 ;   .11111..
 ;   ..111...
 ;   .11111..
 ;   111.111.
 ;   11...11.
 ;   ........
898f: C6 EE 7C 38 7C EE C6 00 00 00 00 00 00 00 00 00

 ;   .11..11.
 ;   .11..11.
 ;   .11..11.
 ;   ..1111..
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ........
899f: 66 66 66 3C 18 18 18 00 00 00 00 00 00 00 00 00

 ;   1111111.
 ;   ....111.
 ;   ...111..
 ;   ..111...
 ;   .111....
 ;   111.....
 ;   1111111.
 ;   ........
89af: FE 0E 1C 38 70 E0 FE 00 00 00 00 00 00 00 00 00

 ;   ........
 ;   ........
 ;   ........
 ;   ........
 ;   ........
 ;   ........
 ;   ........
 ;   ........
89bf: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

 ;   11111111
 ;   11111111
 ;   11111111
 ;   11111111
 ;   11111111
 ;   11111111
 ;   11111111
 ;   11111111
89cf: FF FF FF FF FF FF FF FF 00 00 00 00 00 00 00 00

 ;   22222222
 ;   22222222
 ;   22222222
 ;   22222222
 ;   22222222
 ;   22222222
 ;   22222222
 ;   22222222
89df: 00 00 00 00 00 00 00 00 FF FF FF FF FF FF FF FF

 ;   33333333
 ;   33333333
 ;   33333333
 ;   33333333
 ;   33333333
 ;   33333333
 ;   33333333
 ;   33333333
89ef: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF

 ;   ........
 ;   ........
 ;   ........
 ;   ........
 ;   ..11....
 ;   ...1....
 ;   ..1.....
 ;   ........
89ff: 00 00 00 00 30 10 20 00 00 00 00 00 00 00 00 00

 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ...11...
 ;   ........
 ;   ...11...
 ;   ........
8a0f: 18 18 18 18 18 00 18 00 00 00 00 00 00 00 00 00

 ;   ..11....
 ;   ...1....
 ;   ..1.....
 ;   ........
 ;   ........
 ;   ........
 ;   ........
 ;   ........
8a1f: 30 10 20 00 00 00 00 00 00 00 00 00 00 00 00 00

 ;   .111....
 ;   1...1...
 ;   .1.1....
 ;   ..1.....
 ;   .1.1.1..
 ;   1...1...
 ;   .111.11.
 ;   ........
8a2f: 70 88 50 20 54 88 76 00 00 00 00 00 00 00 00 00

 ;   ........
 ;   ........
 ;   ........
 ;   ........
 ;   ........
 ;   ..11....
 ;   ..11....
 ;   ........
8a3f: 00 00 00 00 00 30 30 00 00 00 00 00 00 00 00 00

 ;   ..1..1..
 ;   ..1..1..
 ;   ..1..1..
 ;   ........
 ;   ........
 ;   ........
 ;   ........
 ;   ........
8a4f: 24 24 24 00 00 00 00 00 00 00 00 00 00 00 00 00

 ;   ..111...
 ;   .1...1..
 ;   .....1..
 ;   ....1...
 ;   ...1....
 ;   ........
 ;   ...1....
 ;   ........
8a5f: 38 44 04 08 10 00 10 00 00 00 00 00 00 00 00 00

 ;   ........
 ;   ........
 ;   ........
 ;   111111..
 ;   ........
 ;   ........
 ;   ........
 ;   ........
8a6f: 00 00 00 FC 00 00 00 00 00 00 00 00 00 00 00 00
"""

for line in patterns.split("\n"):
    line = line.strip()
    if len(line)>4 and line[4] == ":":
        line = line[5:].strip()
        g = '. '
        for t in line.split():
            g += "0x"+t+", "
        line = g[:-2]
    print(line)