#!/bin/sh

qemu-system-aarch64 -M virt,secure=on \
	-cpu cortex-a53 -m 1024 \
	-nographic \
	-bios flash.bin \
	-serial tcp:localhost:54320 -serial tcp:localhost:54321 \
    # -s -S 
