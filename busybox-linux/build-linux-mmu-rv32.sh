#!/bin/sh

set -e

cd linux

# Start with an absolute minimal config
make ARCH=riscv CROSS_COMPILE=riscv32-linux-gnu- allnoconfig

scripts/config -e CONFIG_MMU
scripts/config -e CONFIG_SOC_VIRT
scripts/config -d CONFIG_ARCH_RV64I
scripts/config -e CONFIG_ARCH_RV32I

# This is needed to disable COMPRESSED
scripts/config -e CONFIG_NONPORTABLE
scripts/config -d CONFIG_EFI
scripts/config -d CONFIG_RISCV_ISA_C

scripts/config --set-str CONFIG_CMDLINE "earlycon=simple_uart,mmio,0x3000000 console=ttySU0 init=/init"

scripts/config -e CONFIG_CMDLINE_FORCE

scripts/config -e CONFIG_SIMPLE_UART
scripts/config -e CONFIG_SIMPLE_UART_CONSOLE
scripts/config -e CONFIG_SERIAL_EARLYCON_SIMPLE_UART

scripts/config -e CONFIG_PRINTK_TIME

scripts/config -e CONFIG_BINFMT_SCRIPT
scripts/config -e CONFIG_BINFMT_ELF

scripts/config -e CONFIG_DEVTMPFS
scripts/config -e CONFIG_DEVTMPFS_MOUNT

scripts/config -e CONFIG_BLK_DEV_INITRD
scripts/config -e CONFIG_INITRAMFS_COMPRESSION_NONE
scripts/config --set-str CONFIG_INITRAMFS_SOURCE "../busybox/initramfs.cpio"

# this should hopefully resolve all the dependencies based on our config
make ARCH=riscv CROSS_COMPILE=riscv32-linux-gnu- olddefconfig

make ARCH=riscv CROSS_COMPILE=riscv32-linux-gnu- -j16
