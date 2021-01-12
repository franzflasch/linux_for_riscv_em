# linux_for_riscv_em
Scripts to automate building linux images for my emulator riscv_em  

This was tested in ubuntu 20.04  

# Howto
1. Install my latest riscv64 baremetal toolchain from here:  
https://nightly.link/franzflasch/build-tools-gcc/workflows/riscv64-baremetal/master/toolchain_built_from_tar.zip

And add its bin folder to $PATH  

2. Install prerequisites
```sh
sudo apt install -y git build-essential wget cpio unzip rsync bc libncurses5-dev screen  
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
