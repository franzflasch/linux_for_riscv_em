#!/bin/sh

set -e

LINUX_VERSION="5.10.6"
BUILDROOT_VERSION="2021.02.6"

ROOT_DIR=${PWD}
WORK_DIR=${PWD}/output_mmu_rv32

mkdir -p ${WORK_DIR}

## Buildroot
cd ${WORK_DIR}
wget https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz
tar xvf buildroot-${BUILDROOT_VERSION}.tar.gz
ln -s buildroot-${BUILDROOT_VERSION} buildroot

cp ${ROOT_DIR}/riscv_em_rv32_mmu_buildroot_config ${WORK_DIR}/buildroot-${BUILDROOT_VERSION}/.config
cd ${WORK_DIR}/buildroot-${BUILDROOT_VERSION}

make -j16

## Linux
cd ${WORK_DIR}
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${LINUX_VERSION}.tar.xz
tar xvf linux-${LINUX_VERSION}.tar.xz
ln -s linux-${LINUX_VERSION} linux

cp ${ROOT_DIR}/riscv_em_rv32_mmu_linux_config ${WORK_DIR}/linux-${LINUX_VERSION}/.config
cp ${ROOT_DIR}/patches/linux/* ${WORK_DIR}/linux-${LINUX_VERSION}/

cd ${WORK_DIR}/linux-${LINUX_VERSION}/
patch -p1 < 0001-add-simple-uart.patch
patch -p1 < 0002-revert-commit-2217b982624680d19a80ebb4600d05c8586c4f96.patch

make ARCH=riscv CROSS_COMPILE=riscv32-linux-gnu- -j16

## opensbi
cd ${WORK_DIR}
git clone https://github.com/riscv/opensbi.git opensbi
cd opensbi

git checkout 70ffc3e2e690f2b7bcea456f49206b636420ef5f
git apply ../../patches/opensbi/0001-add-simple-uart.patch

make CROSS_COMPILE=riscv32-linux-gnu- PLATFORM_RISCV_XLEN=32 PLATFORM_RISCV_ISA=rv32ima PLATFORM=generic FW_PAYLOAD_PATH=../linux/arch/riscv/boot/Image
