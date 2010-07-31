module kernel.main;

import video.text.text;
import video.text.misc;

import kernel.x86.gdt;
import kernel.x86.idt;
import kernel.x86.pit;
import kernel.x86.paging;
import kernel.multiboot;
import kernel.x86.memory;
import kernel.x86.keyboard;

multiboot_info* multiboot;

extern(C) void main(uint magic, multiboot_info* multibootAddr) {
	multiboot = multibootAddr;
	
	initGdt();
	initIdt();
	
	initPaging();
	
	ttyInit();
	
	asm {
		sti;
	};
	
	initTimer(50);
	initKeyboard();
	
	asm {
		sti;
	};
	
	puts("configOS v0.1.6 prerelease\n");
	puts("work branch\n");
}
