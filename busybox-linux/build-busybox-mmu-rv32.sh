#!/bin/sh

set -e

# No configuration needed
cd busybox
make CROSS_COMPILE=riscv32-linux-gnu- defconfig

# Disable ssl_client
sed -i 's:CONFIG_SSL_CLIENT=y:# CONFIG_SSL_CLIENT is not set:g' .config
# Disable wget
sed -i 's:CONFIG_WGET=y:# CONFIG_WGET is not set:g' .config
# Enable static
#sed -i 's:# CONFIG_STATIC is not set:CONFIG_STATIC=y:g' .config

make CROSS_COMPILE=riscv32-linux-gnu- oldconfig
make CROSS_COMPILE=riscv32-linux-gnu- -j4
make CROSS_COMPILE=riscv32-linux-gnu- install

cd _install
mkdir -p dev
mkdir -p proc
mkdir -p sys

mknod --mode=0600 dev/console c 5 1
# mknod dev/ram b 1 0

cp ../../../busybox-init init

# these libs are needed for dynamically linked C programs
mkdir -p lib
mkdir -p usr/lib

cp /opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/ld-linux-riscv32-ilp32.so* lib/

mkdir -p opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/
cp /opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/libresolv.so* opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/
cp /opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/libm.so* opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/
cp /opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/libc.so* opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/

# Add hello world example
riscv32-linux-gnu-gcc ../../../hello_world.c -o hello

#mkdir etc
#echo "/usr/lib" > etc/ld.so.conf
#ldconfig -r .

# Compressed initramfs
#find -print0 | cpio -0oH newc | gzip -9 > ../initramfs.cpio.gz

# Uncompressed initramfs, boots faster
find -print0 | cpio -0oH newc > ../initramfs.cpio
