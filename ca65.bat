ca65 bank_00.asm
ca65 bank_01.asm
ca65 bank_02.asm
ca65 bank_03.asm

ld65 -C ld65.cfg bank_00.o bank_01.o bank_02.o bank_03.o

copy /B header.bin + bank_00.bin + bank_01.bin + bank_02.bin + bank_03.bin + chr.chr test.nes

del *.o
del bank_*.bin

pause