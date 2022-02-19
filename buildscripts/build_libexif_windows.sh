#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later AND MIT
#     Copyright (c) 2017-2021 Maxim Biro <nurupo.contributions@gmail.com>
#     Copyright (c) 2021 by The qTox Project Contributors

usage()
{
    echo "Download and build libexif for the windows cross compiling environment"
    echo "Usage: $0 --arch {x86_64|i686}"
}

ARCH=""

while (( $# > 0 )); do
    case $1 in
        --arch) ARCH=$2; shift 2 ;;
        -h|--help) usage; exit 1 ;;
        *) echo "Unexpected argument $1"; usage; exit 1;;
    esac
done

if [ "$ARCH" != "i686" ] && [ "$ARCH" != "x86_64" ]; then
    echo "Unexpected arch $ARCH"
    usage
    exit 1
fi

set -euo pipefail


"$(dirname $0)"/download/download_libexif.sh

CFLAGS="-O2 -g0" ./configure --host="${ARCH}-w64-mingw32" \
                         --prefix=/windows/ \
                         --enable-shared \
                         --disable-static \
                         --disable-docs \
                         --disable-nls

make -j $(nproc)
make install