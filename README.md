# linux_for_riscv_em
Scripts to automate building linux images for my emulator riscv_em  

This was tested in ubuntu 20.04  

# Howto
1. Install my latest prebuilt riscv64 baremetal toolchain from here (the download can take a while to react, as the zip file is generated on the go):  
https://github.com/franzflasch/gcc-build-tools

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
