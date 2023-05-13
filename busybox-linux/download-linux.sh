#!/bin/sh

set -e

LINUX_VERSION=6.1.28

rm -rf linux-${LINUX_VERSION}.tar.xz
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${LINUX_VERSION}.tar.xz
tar xvf linux-${LINUX_VERSION}.tar.xz
ln -s linux-${LINUX_VERSION} linux

cd linux
patch -p1 < ../../../patches/linux/0001-add-simple-uart.patch
