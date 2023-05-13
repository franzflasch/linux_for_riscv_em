#!/bin/sh

set -e

BUSYBOX_VERSION=1.36.0

rm -rf busybox-${BUSYBOX_VERSION}.tar.bz2
wget https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
tar xvf busybox-${BUSYBOX_VERSION}.tar.bz2
ln -s busybox-${BUSYBOX_VERSION} busybox
