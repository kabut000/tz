CC = /usr/bin/aarch64-linux-gnu-gcc
AS = /usr/bin/aarch64-linux-gnu-as
LD = /usr/bin/aarch64-linux-gnu-ld
OBJCOPY = /usr/bin/aarch64-linux-gnu-objcopy

OBJS = monitor.o monitor_main.o 

CFLAGS = -Wall -nostdlib

LFLAGS = -static -T monitor.lds -Wl,--build-id=none

all: flash.bin

flash.bin: monitor.bin secure.bin nonsecure.bin
	dd if=./monitor.bin of=flash.bin bs=4096 conv=notrunc
	dd if=./secure/secure.bin of=flash.bin seek=32 bs=4096 conv=notrunc 
	dd if=./nonsecure/nonsecure.bin of=flash.bin seek=64 bs=4096 conv=notrunc

secure.bin:
	make -C ./secure/

nonsecure.bin:
	make -C ./nonsecure/

monitor.bin: monitor.elf
	$(OBJCOPY) -O binary $< $@

monitor.elf: $(OBJS)
	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@

.SUFFIXES: .c .o 
.SUFFIXES: .S .o 

.c.o: $< 
	$(CC) -c $(CFLAGS) $<

.S.o: $< 
	$(CC) -c $(CFLAGS) $<

clean:
	make clean -C ./secure/
	make clean -C ./nonsecure/
	rm -f *.elf *.o *.bin
