#!/bin/sh

qemu-system-aarch64 -M virt,secure=on \
	-cpu cortex-a53 -m 1024 \
	-nographic \
	-initrd rootfs.cpio.gz \
	-bios flash.bin \
	-kernel Image \
	-serial tcp:localhost:54320 -serial tcp:localhost:54321 \
    # -s -S 
