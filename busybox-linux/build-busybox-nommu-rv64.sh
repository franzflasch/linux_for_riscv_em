#!/bin/sh

set -e

cd busybox
make CROSS_COMPILE=riscv64-linux-uclibc- allnoconfig

# Config is based on buildroot nommu config

# Settings
../../../scripts/config -e CONFIG_LFS
../../../scripts/config -e CONFIG_FEATURE_DEVPTS
../../../scripts/config -e CONFIG_BUSYBOX
../../../scripts/config -e FEATURE_SHOW_SCRIPT
../../../scripts/config -e CONFIG_FEATURE_INSTALLER
../../../scripts/config -e CONFIG_FEATURE_SUID
../../../scripts/config -e CONFIG_FEATURE_SYSLOG_INFO
../../../scripts/config -e CONFIG_STATIC
../../../scripts/config -e CONFIG_NOMMU
../../../scripts/config -e CONFIG_STATIC_LIBGCC
../../../scripts/config -e CONFIG_FLOAT_DURATION
../../../scripts/config -e CONFIG_FEATURE_RTMINMAX
../../../scripts/config -e CONFIG_FEATURE_RTMINMAX_USE_LIBC_DEFINITIONS
../../../scripts/config -e CONFIG_FEATURE_NON_POSIX_CP
../../../scripts/config -e CONFIG_FEATURE_USE_SENDFILE
../../../scripts/config -e CONFIG_MONOTONIC_SYSCALL
../../../scripts/config -e CONFIG_IOCTL_HEX2STR_ERROR
../../../scripts/config -e CONFIG_FEATURE_EDITING
../../../scripts/config --set-val FEATURE_EDITING_MAX_LEN 1024
../../../scripts/config -e CONFIG_FEATURE_EDITING_SAVEHISTORY
../../../scripts/config -e FEATURE_TAB_COMPLETION
../../../scripts/config -d CONFIG_INCLUDE_SUSv2
../../../scripts/config -d CONFIG_FEATURE_UTMP
../../../scripts/config -d CONFIG_FEATURE_WTMP

# Archival Utilities
../../../scripts/config -e CONFIG_ZCAT
../../../scripts/config -e CONFIG_BZCAT
../../../scripts/config -e CONFIG_XZCAT
../../../scripts/config -e CONFIG_UNLZOP
../../../scripts/config -e CONFIG_LZOPCAT

# Coreutils
../../../scripts/config -e CONFIG_FEATURE_VERBOSE
../../../scripts/config -e CONFIG_FEATURE_PRESERVE_HARDLINKS
../../../scripts/config -e CONFIG_FEATURE_HUMAN_READABLE
../../../scripts/config -e CONFIG_BASENAME
../../../scripts/config -e CONFIG_CAT
../../../scripts/config -e CONFIG_FEATURE_CATN
../../../scripts/config -e CONFIG_FEATURE_CATV
../../../scripts/config -e CONFIG_CHGRP
../../../scripts/config -e CONFIG_CHMOD
../../../scripts/config -e CONFIG_CHOWN
../../../scripts/config -e CONFIG_CHROOT
../../../scripts/config -e CONFIG_CKSUM
../../../scripts/config -e CONFIG_CP
../../../scripts/config -e CONFIG_CUT
../../../scripts/config -e CONFIG_FEATURE_CUT_REGEX
../../../scripts/config -e CONFIG_DATE
../../../scripts/config -e CONFIG_FEATURE_DATE_ISOFMT
../../../scripts/config -e CONFIG_FEATURE_DATE_COMPAT
../../../scripts/config -e CONFIG_DD
../../../scripts/config -e CONFIG_FEATURE_DD_SIGNAL_HANDLING
../../../scripts/config -e CONFIG_FEATURE_DD_IBS_OBS
../../../scripts/config -e CONFIG_FEATURE_DD_STATUS
../../../scripts/config -e CONFIG_DF
../../../scripts/config -e CONFIG_FEATURE_SKIP_ROOTFS
../../../scripts/config -e CONFIG_DIRNAME
../../../scripts/config -e CONFIG_DOS2UNIX
../../../scripts/config -e CONFIG_UNIX2DOS
../../../scripts/config -e CONFIG_DU
../../../scripts/config -e CONFIG_ECHO
../../../scripts/config -e FEATURE_FANCY_ECHO
../../../scripts/config -e CONFIG_ENV
../../../scripts/config -e CONFIG_EXPR
../../../scripts/config -e CONFIG_EXPR_MATH_SUPPORT_64
../../../scripts/config -e CONFIG_FACTOR
../../../scripts/config -e CONFIG_FALSE
../../../scripts/config -e CONFIG_FOLD
../../../scripts/config -e CONFIG_HEAD
../../../scripts/config -e FEATURE_FANCY_HEAD
../../../scripts/config -e CONFIG_HOSTID
../../../scripts/config -e CONFIG_ID
../../../scripts/config -e CONFIG_INSTALL
../../../scripts/config -e FEATURE_INSTALL_LONG_OPTIONS
../../../scripts/config -e CONFIG_LINK
../../../scripts/config -e CONFIG_LN
../../../scripts/config -e CONFIG_LOGNAME
../../../scripts/config -e CONFIG_LS
../../../scripts/config -e CONFIG_MD5SUM
../../../scripts/config -e CONFIG_SHA1SUM
../../../scripts/config -e CONFIG_SHA256SUM
../../../scripts/config -e CONFIG_SHA512SUM
../../../scripts/config -e CONFIG_SHA3SUM
../../../scripts/config -e CONFIG_MKDIR
../../../scripts/config -e CONFIG_MKFIFO
../../../scripts/config -e CONFIG_MKNOD
../../../scripts/config -e CONFIG_MV
../../../scripts/config -e CONFIG_NICE
../../../scripts/config -e CONFIG_NL
../../../scripts/config -e CONFIG_NOHUP
../../../scripts/config -e CONFIG_NPROC
../../../scripts/config -e CONFIG_OD
../../../scripts/config -e CONFIG_PASTE
../../../scripts/config -e CONFIG_PRINTENV
../../../scripts/config -e CONFIG_PRINTF
../../../scripts/config -e CONFIG_PWD
../../../scripts/config -e CONFIG_READLINK
../../../scripts/config -e CONFIG_REALPATH
../../../scripts/config -e CONFIG_RM
../../../scripts/config -e CONFIG_RMDIR
../../../scripts/config -e CONFIG_SEQ
../../../scripts/config -e CONFIG_SHRED
../../../scripts/config -e CONFIG_SLEEP
../../../scripts/config -e CONFIG_SORT
../../../scripts/config -e CONFIG_STTY
../../../scripts/config -e CONFIG_SYNC
../../../scripts/config -e CONFIG_TAIL
../../../scripts/config -e CONFIG_TEE
../../../scripts/config -e CONFIG_TEST
../../../scripts/config -e CONFIG_TOUCH
../../../scripts/config -e CONFIG_TR
../../../scripts/config -e CONFIG_TRUE
../../../scripts/config -e CONFIG_TRUNCATE
../../../scripts/config -e CONFIG_TSORT
../../../scripts/config -e CONFIG_TTY
../../../scripts/config -e CONFIG_UNAME
../../../scripts/config -e CONFIG_BB_ARCH
../../../scripts/config -e CONFIG_UNIQ
../../../scripts/config -e CONFIG_UNLINK
../../../scripts/config -e CONFIG_USLEEP
../../../scripts/config -e CONFIG_UUDECODE
../../../scripts/config -e CONFIG_BASE32
../../../scripts/config -e CONFIG_UUENCODE
../../../scripts/config -e CONFIG_WC
../../../scripts/config -e CONFIG_WHO
../../../scripts/config -e CONFIG_W
../../../scripts/config -e CONFIG_WHOAMI
../../../scripts/config -e CONFIG_YES

# Init utilities
../../../scripts/config -e CONFIG_HALT
../../../scripts/config -e CONFIG_POWEROFF
../../../scripts/config -e CONFIG_REBOOT
../../../scripts/config -e CONFIG_FEATURE_WAIT_FOR_INIT
../../../scripts/config -e CONFIG_INIT
../../../scripts/config -e CONFIG_LINUXRC
../../../scripts/config -e CONFIG_FEATURE_USE_INITTAB
../../../scripts/config -e CONFIG_FEATURE_KILL_REMOVED
../../../scripts/config -e CONFIG_FEATURE_INIT_SCTTY
../../../scripts/config -e CONFIG_FEATURE_INIT_SYSLOG
../../../scripts/config -e FEATURE_INIT_QUIET
../../../scripts/config -e CONFIG_FEATURE_INIT_MODIFY_CMDLINE

# Login/Password Management Utilities
../../../scripts/config -e CONFIG_GETTY
../../../scripts/config -e CONFIG_LOGIN
../../../scripts/config -d CONFIG_LOGIN_SCRIPTS
../../../scripts/config -d CONFIG_FEATURE_NOLOGIN
../../../scripts/config -d CONFIG_FEATURE_SECURETTY

# Linux System Utilities
../../../scripts/config -e CONFIG_DMESG
../../../scripts/config -e CONFIG_FEATURE_DMESG_PRETTY
../../../scripts/config -e CONFIG_MOUNT
../../../scripts/config -d CONFIG_SWAPON
../../../scripts/config -d CONFIG_SWAPOFF

# Miscellaneous Utilities
../../../scripts/config -e CONFIG_SEEDRNG

# Networking Utilities
../../../scripts/config -e CONFIG_HOSTNAME

# Process Utilities
../../../scripts/config -e CONFIG_KILL
../../../scripts/config -e CONFIG_KILLALL
../../../scripts/config -e CONFIG_KILLALL5
../../../scripts/config -e CONFIG_PS
../../../scripts/config -e CONFIG_FEATURE_PS_WIDE
../../../scripts/config -e CONFIG_FEATURE_PS_LONG
../../../scripts/config -e CONFIG_UPTIME

# Shells
../../../scripts/config -e CONFIG_CTTYHACK
../../../scripts/config -d CONFIG_ASH
../../../scripts/config -e CONFIG_HUSH
../../../scripts/config -e CONFIG_HUSH_BASH_COMPAT
../../../scripts/config -e CONFIG_HUSH_BRACE_EXPANSION
../../../scripts/config -e CONFIG_HUSH_HELP
../../../scripts/config -e CONFIG_HUSH_INTERACTIVE
../../../scripts/config -e CONFIG_HUSH_SAVEHISTORY
../../../scripts/config -e CONFIG_HUSH_JOB
../../../scripts/config -e CONFIG_HUSH_TICK
../../../scripts/config -e CONFIG_HUSH_IF
../../../scripts/config -e CONFIG_HUSH_LOOPS
../../../scripts/config -e CONFIG_HUSH_CASE
../../../scripts/config -e CONFIG_HUSH_FUNCTIONS
../../../scripts/config -e CONFIG_HUSH_LOCAL
../../../scripts/config -e CONFIG_HUSH_RANDOM_SUPPORT
../../../scripts/config -e CONFIG_HUSH_EXPORT_N
../../../scripts/config -e CONFIG_HUSH_MODE_X
../../../scripts/config -e HUSH_ECHO
../../../scripts/config -e HUSH_PRINTF
../../../scripts/config -e HUSH_EXPORT
../../../scripts/config -e HUSH_SET
../../../scripts/config -e HUSH_UNSET

make CROSS_COMPILE=riscv64-linux-uclibc- oldconfig
make V=1 SKIP_STRIP=y CFLAGS="-march=rv64ima -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -Os -g0  -fPIC  -Wl,-elf2flt=-r -static" EXTRA_LDFLAGS=" -Wl,-elf2flt=-r -static" CROSS_COMPILE=riscv64-linux-uclibc- -j8
make V=1 SKIP_STRIP=y CFLAGS="-march=rv64ima -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -Os -g0  -fPIC  -Wl,-elf2flt=-r -static" EXTRA_LDFLAGS=" -Wl,-elf2flt=-r -static" CROSS_COMPILE=riscv64-linux-uclibc- install

cd _install
mkdir -p dev
mkdir -p proc
mkdir -p sys

mknod --mode=0622 dev/console c 5 1
# mknod dev/ram b 1 0

chown -h -R 0:0 .
install -m 0755 ../../../busybox-init init

# these libs are needed for dynamically linked C programs
mkdir -p lib
mkdir -p usr/lib

#cp /opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/ld-linux-riscv32-ilp32.so* lib/

#mkdir -p opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/
#cp /opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/libresolv.so* opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/
#cp /opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/libm.so* opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/
#cp /opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/libc.so* opt/local/cross-tool-riscv32-gcc13/riscv32-linux-gnu/lib/

# Add hello world example
#riscv32-linux-gnu-gcc ../../../hello_world.c -o hello

#mkdir etc
#echo "/usr/lib" > etc/ld.so.conf
#ldconfig -r .

# Compressed initramfs
#find -print0 | cpio -0oH newc | gzip -9 > ../initramfs.cpio.gz

# setuid busybox
chmod u+s bin/busybox

# Uncompressed initramfs, boots faster
find -print0 | cpio -0oH newc > ../initramfs.cpio
