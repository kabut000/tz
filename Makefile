CC = /usr/bin/aarch64-linux-gnu-gcc
AS = /usr/bin/aarch64-linux-gnu-as
LD = /usr/bin/aarch64-linux-gnu-ld
OBJCOPY = /usr/bin/aarch64-linux-gnu-objcopy

OBJS = monitor.o monitor_main.o 

CFLAGS = -Wall -nostdlib

LFLAGS = -static -T monitor.lds -Wl,--build-id=none

all: flash.bin

flash.bin: monitor.bin secure.bin 
	dd if=./monitor.bin of=flash.bin bs=4096 conv=notrunc
	dd if=./secure/secure.bin of=flash.bin seek=32 bs=4096 conv=notrunc 
	dd if=./QEMU_EFI.fd of=flash.bin seek=64 bs=4096 conv=notrunc

secure.bin:
	make -C ./secure/

monitor.bin: monitor.elf
	$(OBJCOPY) -O binary $< $@

monitor.elf: $(OBJS)
	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@

monitor.o: monitor.S 
	$(AS) -c $< -o $@

%.o: %.c 
	$(CC) -c $< -o $@

clean:
	make clean -C ./secure/
	rm -f *.elf *.o *.bin
