RGSBASM=rgbasm
RGBLINK=rgblink
RGBFIX=rgbfix
SAMEBOY=../../SameBoy-0.14.7/build/bin/SDL/sameboy

.PHONY: all fix clean run

build: main.o
	$(RGBLINK) -o rom.gb main.o;\
	$(MAKE) fix

main.o: main.asm
	$(RGSBASM) -o main.o main.asm

fix:
	$(RGBFIX) -v -p 0 rom.gb

run: build
	$(SAMEBOY) rom.gb

clean:
	rm -f *.o *.gb