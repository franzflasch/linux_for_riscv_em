#!/bin/sh

set -e

rm -rf opensbi
git clone https://github.com/riscv/opensbi.git opensbi

cd opensbi
git checkout v1.9
git apply ../../../patches/opensbi/0001-add-simple-uart.patch
