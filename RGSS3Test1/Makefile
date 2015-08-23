#!/usr/bin/make -f

test: Data/Scripts.rvdata2 Game.exe System/RGSS301.dll
	./Game
	cat stdout.txt

Data/Scripts.rvdata2: $(wildcard Scripts/*)
	ruby genscript.rb
