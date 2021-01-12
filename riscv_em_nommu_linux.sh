#!/bin/sh

set -e

LINUX_VERSION="5.10.6"
BUILDROOT_VERSION="2020.11.1"

ROOT_DIR=${PWD}
WORK_DIR=${PWD}/output

mkdir -p ${WORK_DIR}

## Buildroot
cd ${WORK_DIR}
wget https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz
tar xvf buildroot-${BUILDROOT_VERSION}.tar.gz
ln -s buildroot-${BUILDROOT_VERSION} buildroot

cp ${ROOT_DIR}/riscv_em_nommu_buildroot_config ${WORK_DIR}/buildroot-${BUILDROOT_VERSION}/.config
cp ${ROOT_DIR}/patches/buildroot/* ${WORK_DIR}/buildroot-${BUILDROOT_VERSION}/

cd ${WORK_DIR}/buildroot-${BUILDROOT_VERSION}
patch -p1 < 0001-Make-MMU-for-riscv-optional.patch
patch -p1 < 0002-Toolchain-fix.patch
patch -p1 < 0003-NPTL-fix.patch
patch -p1 < 0004-elf2flt-add-riscv-support.patch
patch -p1 < 0005-uclibc-riscv-nommu-support.patch
patch -p1 < 0006-riscv64-nommu-defconfig.patch
patch -p1 < 0007-add-busybox-small.config.patch

make -j16

## Linux
cd ${WORK_DIR}
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${LINUX_VERSION}.tar.xz
tar xvf linux-${LINUX_VERSION}.tar.xz
ln -s linux-${LINUX_VERSION} linux

cp ${ROOT_DIR}/riscv_em_nommu_linux_config ${WORK_DIR}/linux-${LINUX_VERSION}/.config
cp ${ROOT_DIR}/patches/linux/* ${WORK_DIR}/linux-${LINUX_VERSION}/

cd ${WORK_DIR}/linux-${LINUX_VERSION}/
patch -p1 < 0001-add-simple-uart.patch
patch -p1 < 0002-revert-commit-2217b982624680d19a80ebb4600d05c8586c4f96.patch

make ARCH=riscv CROSS_COMPILE=riscv64-none-elf- -j16 loader
riscv64-none-elf-objcopy -O binary arch/riscv/boot/loader loader_64.bin
