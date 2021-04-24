#!/bin/bash
set -eu
autoreconf -iv
./configure \
    --prefix=/mingw64 \
    --build=x86_64-w64-mingw32 \
    --host=x86_64-w64-mingw32 \
    --target=x86_64-w64-mingw32
make
make install
