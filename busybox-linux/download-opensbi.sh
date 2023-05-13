#!/bin/sh

set -e

rm -rf opensbi
git clone https://github.com/riscv/opensbi.git opensbi

cd opensbi
git checkout 4489876e933d8ba0d8bc6c64bae71e295d45faac
git apply ../../../patches/opensbi/0001-add-simple-uart.patch
