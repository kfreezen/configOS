module kernel.main;

import video.text.text;
import video.text.misc;

import kernel.x86.gdt;
import kernel.x86.idt;
import kernel.x86.pit;
import kernel.x86.paging;
<<<<<<< HEAD
=======
import kernel.multiboot;
import kernel.x86.memory;
import kernel.x86.keyboard;
>>>>>>> cfgos/work

multiboot_info* multiboot;

extern(C) void main(uint magic, multiboot_info* multibootAddr) {
	multiboot = multibootAddr;
	
	initGdt();
	initIdt();
	initPaging();
	
	initPaging();
	
	ttyInit();
	
	asm {
		sti;
	};
	
<<<<<<< HEAD
	puts("configOS v0.1.5 prerelease\n");
	
=======
	initTimer(50);
	initKeyboard();
	
	asm {
		sti;
	};
	
	puts("configOS v0.1.6 prerelease\n");
	puts("work branch\n");
>>>>>>> cfgos/work
}
