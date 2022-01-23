CC = /usr/bin/aarch64-linux-gnu-gcc
AS = /usr/bin/aarch64-linux-gnu-as
LD = /usr/bin/aarch64-linux-gnu-ld
OBJCOPY = /usr/bin/aarch64-linux-gnu-objcopy

OBJS = nonsecure.o nonsecure_main.o 

CFLAGS = -Wall -nostdlib

LFLAGS = -static -T nonsecure.lds -Wl,--build-id=none

all: nonsecure.bin

clean:
	rm -f *.elf *.o *.bin

nonsecure.bin: nonsecure.elf
	$(OBJCOPY) -O binary $< $@

nonsecure.elf: $(OBJS)
	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@

.SUFFIXES: .c .o 
.SUFFIXES: .S .o 

.c.o: $< 
	$(CC) -c $(CFLAGS) $<

.S.o: $< 
	$(CC) -c $(CFLAGS) $<
