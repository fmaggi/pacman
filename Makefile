USER = fran
MOUNT = /media/$(USER)/boot
ARMGNU ?= aarch64-linux-gnu

AOPS = --warn --fatal-warnings

all: clean boot

asm: kernel.img

clean :
	rm -f *.o
	rm -f *.img
	rm -f *.hex
	rm -f *.elf
	rm -f *.list
	rm -f *.img
	rm -f memory_map.txt

main.o : main.s
	$(ARMGNU)-as $(AOPS) main.s gpio.s app.s shape.s map.s math.s pacman.s -o main.o


kernel.img : memmap main.o
	$(ARMGNU)-ld main.o -T memmap -o main.elf -M > memory_map.txt
	$(ARMGNU)-objdump -D main.elf > main.list
	$(ARMGNU)-objcopy main.elf -O ihex main.hex
	$(ARMGNU)-objcopy main.elf -O binary kernel8.img

boot: asm
	rm -f -- $(MOUNT)/kernel8.img
	cp kernel8.img $(MOUNT)/kernel8.img
