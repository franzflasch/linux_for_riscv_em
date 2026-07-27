#!/bin/bash

set -e

cd "$(dirname "$0")/busybox-linux"
./build-all-rv32-mmu.sh
