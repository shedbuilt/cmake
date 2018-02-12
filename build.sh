#!/bin/bash
# Prevent installation in /usr/lib64
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake && \
./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --docdir=/share/doc/cmake-3.10.2 && \
make -j $SHED_NUMJOBS && \
make DESTDIR="$SHED_FAKEROOT" install