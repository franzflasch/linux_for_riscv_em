#!/bin/sh

set -e

# No configuration needed
cd opensbi
make CROSS_COMPILE=riscv32-linux-gnu- PLATFORM_RISCV_XLEN=32 PLATFORM_RISCV_ISA=rv32ima_zicsr_zifencei PLATFORM=generic FW_PAYLOAD_PATH=../linux/arch/riscv/boot/Image
