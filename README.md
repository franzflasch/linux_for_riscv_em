# linux_for_riscv_em

Build automation for producing bootable Linux images for the [riscv_em](https://github.com/franzflasch/riscv_em) emulator.

The build produces a minimal Linux environment: a cross-compiled kernel with a BusyBox userspace packaged as an embedded initramfs, resulting in a single flat binary ready to load into the emulator.

Currently supported target:

| Target | Arch | MMU | Output |
|--------|------|-----|--------|
| NoMMU  | RV64 | No  | `busybox-linux/output/loader_64.bin` |
| MMU    | RV32 | Yes | `busybox-linux/output/opensbi/build/platform/generic/firmware/fw_payload.bin` |

Component versions:

- **Linux** 6.18.40
- **BusyBox** 1.38.0
- **OpenSBI** v1.9 (MMU build only)

---

## Prerequisites

### System packages

Tested on Ubuntu 24.04. Install the required packages:

```sh
sudo apt install -y \
    git build-essential wget cpio unzip rsync bc \
    libncurses5-dev bison flex file fakeroot
```

### Toolchain (NoMMU — RV64)

Install the RV64 uClibc cross-toolchain (used for both the kernel and BusyBox):

- Download from:
  https://nightly.link/franzflasch/gcc-build-tools/workflows/riscv64-uclibc/main/toolchain_built_from_tar

  *(The download may take a moment to react as the zip is generated on demand.)*

Extract and add the toolchain's `bin/` folder to your `$PATH`:

```sh
export PATH=/path/to/toolchain/bin:$PATH
```

The build scripts expect the prefix `riscv64-linux-uclibc-` to be available in `$PATH`.

### Toolchain (MMU — RV32)

Install the RV32 Linux GNU cross-toolchain:

- Download from:
  https://nightly.link/franzflasch/gcc-build-tools/workflows/riscv32/main/toolchain_built_from_tar

  *(The download may take a moment to react as the zip is generated on demand.)*

Extract to `/opt/local/cross-tool-riscv32-gcc16` and add its `bin/` folder to your `$PATH`:

```sh
export PATH=/opt/local/cross-tool-riscv32-gcc16/bin:$PATH
```

The build scripts expect the prefix `riscv32-linux-gnu-` to be available in `$PATH` and also copy shared libraries directly from `/opt/local/cross-tool-riscv32-gcc16/riscv32-linux-gnu/lib/` into the rootfs, so the installation path must match.

---

## Building (RV64 NoMMU)

Run the top-level build script from the repo root:

```sh
./build-rv64-nommu.sh
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

## Building (RV32 MMU)

Run the top-level build script from the repo root:

```sh
./build-rv32-mmu.sh
```

The script downloads sources, applies patches, builds BusyBox, then builds the Linux kernel, then builds OpenSBI with the kernel as its payload. All intermediate files land in `busybox-linux/output/`.

The final binary is:

```
busybox-linux/output/opensbi/build/platform/generic/firmware/fw_payload.bin
```

### Resumable builds

Same idempotent state-tracking as the NoMMU build. To force a full rebuild:

```sh
rm -rf busybox-linux/output
```

---

## How it works

### NoMMU (RV64)

```
download-busybox.sh          -> BusyBox 1.38.0 source
build-busybox-nommu-rv64.sh  -> allnoconfig + selective Kconfig enables
                              -> compiled with BINFMT_FLAT + elf2flt + static linking
                              -> packaged as initramfs.cpio

download-linux.sh            -> Linux 6.18.40 + custom patches applied
build-linux-nommu-rv64.sh    -> allnoconfig + selective Kconfig enables
                              -> initramfs.cpio embedded into the kernel image
                              -> objcopy to flat binary -> loader_64.bin
```

### MMU (RV32)

```
download-busybox.sh          -> BusyBox 1.38.0 source
build-busybox-mmu-rv32.sh    -> defconfig, dynamically linked ELF
                              -> shared libs copied from toolchain sysroot into rootfs
                              -> packaged as initramfs.cpio

download-linux.sh            -> Linux 6.18.40 + custom patches applied
build-linux-mmu-rv32.sh      -> allnoconfig + selective Kconfig enables (MMU, sv32, ELF)
                              -> initramfs.cpio embedded into the kernel image

download-opensbi.sh          -> OpenSBI v1.9 + simple-uart patch applied
build-opensbi-mmu-rv32.sh    -> fw_payload wrapping the kernel Image
                              -> output: fw_payload.bin
```

**Kernel configuration philosophy:** Both the kernel and BusyBox start from `allnoconfig` (absolute minimum) and selectively enable only what is needed via `scripts/config`. This keeps the images small and boot times fast.

**Initramfs:** The BusyBox rootfs CPIO archive is embedded directly into the kernel image (uncompressed, for faster boot). The `/init` script mounts `devtmpfs`, `proc`, and `sysfs`, then drops to a `hush` shell.

**NoMMU userspace:** Without an MMU there is no virtual address space isolation, so standard ELF dynamic linking is not possible. BusyBox is built statically using `BINFMT_FLAT` format via `elf2flt`, which is the correct approach for NoMMU Linux.

**MMU userspace:** Uses standard ELF with dynamic linking. Shared libraries (`libc`, `libm`, `libresolv`, `ld-linux`) are taken from the toolchain sysroot and bundled into the rootfs. OpenSBI acts as firmware (SBI = Supervisor Binary Interface), initialising the hardware and booting the kernel in supervisor mode.

---

## Repository structure

```
linux_for_riscv_em/
├── build-rv64-nommu.sh     # Top-level entry point (NoMMU) — run from repo root
├── build-rv32-mmu.sh       # Top-level entry point (MMU)   — run from repo root
├── busybox-linux/          # Build scripts
│   ├── build-all-rv64-nommu.sh       # NoMMU orchestrator (called by top-level script)
│   ├── build-all-rv32-mmu.sh         # MMU orchestrator (called by top-level script)
│   ├── build-busybox-nommu-rv64.sh   # BusyBox cross-compile + initramfs packaging (NoMMU)
│   ├── build-busybox-mmu-rv32.sh     # BusyBox cross-compile + initramfs packaging (MMU)
│   ├── build-linux-nommu-rv64.sh     # Linux kernel build (NoMMU)
│   ├── build-linux-mmu-rv32.sh       # Linux kernel build (MMU)
│   ├── build-opensbi-mmu-rv32.sh     # OpenSBI firmware build (MMU only)
│   ├── download-busybox.sh           # Downloads BusyBox 1.38.0
│   ├── download-linux.sh             # Downloads Linux 6.18.40 + applies patches
│   ├── download-opensbi.sh           # Clones OpenSBI v1.9 + applies patch
│   └── busybox-init                  # /init script (PID 1)
│
├── patches/
│   ├── linux/
│   │   └── 0001-add-simple-uart.patch    # Custom UART driver for the emulator
│   └── opensbi/
│       └── 0001-add-simple-uart.patch    # Custom UART driver for OpenSBI
│
├── scripts/
│   └── config              # Kconfig option manipulation utility (from the kernel tree)
│
```

---

## Patches

### `patches/linux/0001-add-simple-uart.patch`

Adds a custom `simple_uart` driver (`CONFIG_SIMPLE_UART`) to the Linux kernel. This driver targets the MMIO UART at address `0x3000000` implemented by the `riscv_em` emulator. It is used for both earlycon and the main console:

```
earlycon=simple_uart,mmio,0x3000000 console=ttySU0
```

### `patches/opensbi/0001-add-simple-uart.patch`

Adds the same `simple_uart` driver to OpenSBI, registered as an FDT serial driver with `compatible = "simple-uart"`. OpenSBI uses it as its SBI console (before handing off to the Linux kernel), matching the UART node in the emulator's device tree.


