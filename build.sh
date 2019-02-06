#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_PREFIX="/usr"
SHED_PKG_LOCAL_DOCDIR="/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION}"

# Prevent installation in /usr/lib64
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

# Perform bootstrap build
./bootstrap --prefix=${SHED_PKG_LOCAL_PREFIX}        \
            --system-libs                            \
            --mandir=/share/man                      \
            --no-system-jsoncpp                      \
            --no-system-librhash                     \
            --docdir=${SHED_PKG_LOCAL_DOCDIR} &&
make -j $SHED_NUM_JOBS &&

# Install
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1

# Prune Documentation
if [ -z "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    rm -rf "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_PREFIX}${SHED_PKG_LOCAL_DOCDIR}"
fi
