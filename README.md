# linux_for_riscv_em
Scripts to automate building linux images for my emulator riscv_em  

This was tested in ubuntu 20.04 and ubuntu 21.10 

## Howto RISCV64 (NOMMU build)
1. Install my latest riscv64 baremetal toolchain from here (the download can take a while to react, as the zip file is generated on the go):  
https://nightly.link/franzflasch/gcc-build-tools/workflows/riscv64-baremetal/main/toolchain_built_from_tar

And add its bin folder to $PATH  

2. Install prerequisites
```sh
sudo apt install -y git build-essential wget cpio unzip rsync bc libncurses5-dev screen bison file flex  
```
Hopefully I did not forget any...  

3. Build rootfs and linux with:
```sh
./riscv_em_nommu_linux.sh  
```

The result will be a merged (linux+rootfs) flat binary:  
```sh
output/linux/loader_64.bin
```

## Howto RISCV32 (MMU build)
1. Install my latest riscv32 toolchain from here (the download can take a while to react, as the zip file is generated on the go):  
https://nightly.link/franzflasch/gcc-build-tools/workflows/riscv32/main/toolchain_built_from_tar

And add its bin folder to $PATH  

2. Install prerequisites
```sh
sudo apt install -y git build-essential wget cpio unzip rsync bc libncurses5-dev screen bison file flex 
```
Hopefully I did not forget any...  

3. Build rootfs and linux with:
```sh
./riscv_em_rv32_mmu_linux.sh  
```

The result will be a merged (linux+rootfs) binary, inside the opensbi build folder:
```sh
output_mmu_rv32/opensbi/build/platform/generic/firmware/fw_payload.bin
```
