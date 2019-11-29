#!/usr/bin/make -f

CC = gcc
CC_OPTS = -Wall -Wextra -g -I/usr/include/SDL2
LD_OPTS = -lSDL2 -lSDL2_ttf

# 

_objs = main background time countdown fireworks
objs = $(_objs:%=obj/%.o)

_incs = 
incs = $(_incs:%=src/%.h)

#

.PHONY: default clean dirs

#

default: dirs bin/new-year-2020

bin/new-year-2020: $(objs)
	$(CC) $(CC_OPTS) -o $@ $^ $(LD_OPTS)

clean:
	rm -rf bin/**
	rm -rf obj/**

#

dirs: bin obj

bin:
	mkdir -p $@
	ln -s ../data $@/data

obj:
	mkdir -p $@

#

obj/%.o: src/%.c $(incs)
	$(CC) $(CC_OPTS) -c -o $@ $<
