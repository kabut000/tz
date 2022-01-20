#!/bin/sh

qemu-system-aarch64 -M virt,secure=on \
	-cpu cortex-a53 -m 1024 \
	-serial tcp:localhost:54320 -serial tcp:localhost:54321 \
	-nographic \
	-initrd rootfs.cpio.gz \
	-bios flash.bin \
	-kernel Image \
    # -s -S 

# qemu-system-aarch64 -M virt,secure=on \
# 	-cpu cortex-a53 -m 1024 \
# 	-nographic \
# 	-kernel QEMU_EFI.fd 