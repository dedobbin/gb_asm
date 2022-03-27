@ECHO OFF

set RGSBASM=rgbasm.exe
set RGBLINK=rgblink
set RGBFIX=rgbfix

%RGSBASM% -o main.o main.asm 
%RGSBASM% -o game.o game.asm
%RGSBASM% -o joypad.o joypad.asm
%RGSBASM% -o helpers.o helpers.asm
%RGSBASM% -o ball.o ball.asm
%RGBLINK% -m rom.map -n rom.sym -o rom.gb game.o main.o helpers.o joypad.o ball.o
%RGBFIX% -v -p 0 rom.gb