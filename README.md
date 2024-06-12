On MacOS run `make` to reproduce the crash.

The makefile compiles a binary and a dynamic library, and repeatedly loads the dylib, calls a function, and unloads it in a loop.

By default this should crash after one reload, specifically, the line `world.entity().set(vec2{400.0f, 400.0f});` causes the crash.
while `world.entity().emplace<vec2>(400.0f, 400.0f);` runs fine for hundreds of thousands of reloads without crashing.

Tested on MacBook Pro M1 on MacOS Ventura 13.4 with clang 14.0.3.
