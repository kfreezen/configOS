module kernel.main;

import video.text.text;
import video.text.misc;

import kernel.x86.pit;
import kernel.multiboot;
import kernel.x86.memory;
import kernel.x86.keyboard;
import misc.common;
import kernel.x86.init;
import kernel.x86.floppy;

multiboot_info* multiboot;

extern(C) void main() {
	
	ubyte* sector;
	
	puts("configOS v0.1.6 prerelease\n");
	puts("work branch\n");

	putc('\n');
	displaySystemInfo();
	sector = floppyReadSector(0);
	
	int i;
	for(i = 0; i < 512; i++) {
		printx(sector[i]);
		putc(' ');
		if((i % 32) == 0) {
			putc('\n');
			getc();
		}
	}
	putc('\n');
	
	printx(cast(uint) sector);
	putc('\n');
}
