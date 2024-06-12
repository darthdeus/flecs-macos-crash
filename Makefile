W=-Wno-unused-variable -Wno-unused-parameter -Wno-unused-function -Wall -Wextra -Wuninitialized -Wmissing-field-initializers
CXX = clang++
GU=
# CXX = g++
# GU=--no-gnu-unique

CXXFLAGS = -O0 -fno-omit-frame-pointer -ggdb3 -std=c++20 $(GU)
INCLUDES = -I./vendor

# ARCH=-arch arm64
ARCH=

.PHONY: run main lib

crash: clean liblibrary.so main

watch-main:
	ulimit -c unlimited
	watchexec -r --stop-signal=SIGKILL -w src -w Makefile -w main -- make main

watch-lib:
	watchexec -r -w Makefile -w src -w include -- time make liblibrary.so

bin/flecs.o: vendor/flecs.c vendor/flecs.h Makefile
	$(CC) -g3 -fPIC -std=gnu99 -c vendor/flecs.c -o bin/flecs.o

main: main/main.cpp bin/flecs.o liblibrary.so
	$(CXX) $(CXXFLAGS) $(ARCH) $(INCLUDES) $(LINKS) $(W) -o bin/main main/main.cpp bin/flecs.o
	./bin/main

liblibrary.so: src/library.cpp bin/flecs.o
	$(CXX) $(CXXFLAGS) $(ARCH) $(INCLUDES) $(W) -rdynamic -shared -fPIC -o bin/tmp-liblibrary.so src/library.cpp bin/flecs.o
	touch bin/tmp-liblibrary.so
	mv bin/tmp-liblibrary.so bin/liblibrary.so

clean:
	rm -f bin/main bin/liblibrary.so bin/flecs.o

lint:
	cppcheck -Ivendor --config-exclude=vendor --enable=all --suppress=missingIncludeSystem --suppress=preprocessorErrorDirective --suppress=unusedStructMember main/* src/* include/*
