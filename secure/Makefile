CC = /usr/bin/aarch64-linux-gnu-gcc
AS = /usr/bin/aarch64-linux-gnu-as
LD = /usr/bin/aarch64-linux-gnu-ld
OBJCOPY = /usr/bin/aarch64-linux-gnu-objcopy

OBJS = secure.o secure_main.o 

CFLAGS = -Wall -nostdlib

LFLAGS = -static -T secure.lds -Wl,--build-id=none

all: secure.bin

clean:
	rm -f *.elf *.o *.bin

secure.o: secure.S 
	$(AS) -c $< -o $@

%.o: %.c 
	$(CC) -c $< -o $@

secure.elf: $(OBJS)
	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@

secure.bin: secure.elf
	$(OBJCOPY) -O binary $< $@
