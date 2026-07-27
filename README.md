# linux_for_riscv_em

Build automation for producing bootable Linux images for the [riscv_em](https://github.com/franzflasch/riscv_em) emulator.

The build produces a minimal Linux environment: a cross-compiled kernel with a BusyBox userspace packaged as an embedded initramfs, resulting in a single flat binary ready to load into the emulator.

Currently supported target:

| Target | Arch | MMU | Output |
|--------|------|-----|--------|
| NoMMU  | RV64 | No  | `output/loader_64.bin` |

Component versions:

- **Linux** 6.18.40
- **BusyBox** 1.38.0

---

## Prerequisites

### System packages

Tested on Ubuntu 24.04. Install the required packages:

```sh
sudo apt install -y \
    git build-essential wget cpio unzip rsync bc \
    libncurses5-dev bison flex file fakeroot
```

### Toolchain

Install the RV64 uClibc cross-toolchain (used for both the kernel and BusyBox):

- Download from:
  https://nightly.link/franzflasch/gcc-build-tools/workflows/riscv64-uclibc/main/toolchain_built_from_tar

  *(The download may take a moment to react as the zip is generated on demand.)*

Extract and add the toolchain's `bin/` folder to your `$PATH`:

```sh
export PATH=/path/to/toolchain/bin:$PATH
```

The build scripts expect the prefix `riscv64-linux-uclibc-` to be available in `$PATH`.

---

## Building (RV64 NoMMU)

Run the top-level orchestrator from the `busybox-linux/` directory:

```sh
cd busybox-linux
./build-all-rv64-nommu.sh
```

The script downloads sources, applies patches, builds BusyBox, then builds the Linux kernel. All intermediate files land in `busybox-linux/output/`.

The final binary is:

```
busybox-linux/output/loader_64.bin
```

### Resumable builds

The build is idempotent. Each stage is tracked by a `state_<step>` sentinel file inside `output/`. If a build is interrupted, re-running the script skips already-completed stages. To force a full rebuild, remove the `output/` directory:

```sh
rm -rf busybox-linux/output
```

---

## How it works

```
download-busybox.sh     -> BusyBox 1.38.0 source
build-busybox-nommu-rv64.sh  -> allnoconfig + selective Kconfig enables
                              -> compiled with BINFMT_FLAT + elf2flt + static linking
                              -> packaged as initramfs.cpio

download-linux.sh       -> Linux 6.18.40 + custom patches applied
build-linux-nommu-rv64.sh    -> allnoconfig + selective Kconfig enables
                              -> initramfs.cpio embedded into the kernel image
                              -> objcopy to flat binary -> loader_64.bin
```

**Kernel configuration philosophy:** Both the kernel and BusyBox start from `allnoconfig` (absolute minimum) and selectively enable only what is needed via `scripts/config`. This keeps the images small and boot times fast.

**Initramfs:** The BusyBox rootfs CPIO archive is embedded directly into the kernel image (uncompressed, for faster boot). The `/init` script mounts `devtmpfs`, `proc`, and `sysfs`, then drops to a `hush` shell.

**NoMMU userspace:** Without an MMU there is no virtual address space isolation, so standard ELF dynamic linking is not possible. BusyBox is built statically using `BINFMT_FLAT` format via `elf2flt`, which is the correct approach for NoMMU Linux.

---

## Repository structure

```
linux_for_riscv_em/
├── busybox-linux/          # Current build scripts
│   ├── build-all-rv64-nommu.sh       # Top-level entry point (NoMMU)
│   ├── build-busybox-nommu-rv64.sh   # BusyBox cross-compile + initramfs packaging
│   ├── build-linux-nommu-rv64.sh     # Linux kernel build
│   ├── download-busybox.sh           # Downloads BusyBox 1.38.0
│   ├── download-linux.sh             # Downloads Linux 6.18.40 + applies patches
│   └── busybox-init                  # /init script (PID 1)
│
├── patches/
│   └── linux/
│       └── 0001-add-simple-uart.patch              # Custom UART driver for the emulator
│
├── scripts/
│   └── config              # Kconfig option manipulation utility (from the kernel tree)
│
```

---

## Patches

### `0001-add-simple-uart.patch`

Adds a custom `simple_uart` driver (`CONFIG_SIMPLE_UART`) to the Linux kernel. This driver targets the MMIO UART at address `0x3000000` implemented by the `riscv_em` emulator. It is used for both earlycon and the main console:

```
earlycon=simple_uart,mmio,0x3000000 console=ttySU0
```


