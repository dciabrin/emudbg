#!/bin/bash
set -eu
autoreconf -iv
./configure --prefix=${PREFIX} ${BUILD_HOST_PARAMS}
make
sudo make install
