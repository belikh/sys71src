CC = m68k-linux-gnu-gcc
LD = m68k-linux-gnu-ld
OBJCOPY = m68k-linux-gnu-objcopy

# Use -fPIC for Position Independent Code since ROM loads us anywhere.
# -msep-data might be needed if we want separate data segment, but -fPIC is standard.
CFLAGS = -m68030 -O2 -Wall -fno-builtin -nostdlib -Iinclude -fPIC
LDFLAGS = -T linker.ld

all: boot.img

kernel.elf: kernel/head.o kernel/main.o kernel/video.o
	$(LD) $(LDFLAGS) -o $@ $^

kernel.bin: kernel.elf
	$(OBJCOPY) -O binary $< $@

boot.img: kernel.bin tools/create_image.sh
	./tools/create_image.sh

clean:
	rm -f kernel/*.o kernel.elf kernel.bin boot.img

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.S
	$(CC) $(CFLAGS) -c -o $@ $<
