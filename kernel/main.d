module kernel.main;

import video.text.text;
import video.text.misc;

import kernel.x86.gdt;
import kernel.x86.idt;
import kernel.x86.pit;
import kernel.x86.paging;

extern(C) void main(uint magic, uint multibootAddr) {
	initGdt();
	initIdt();
	initPaging();
	
	ttyInit();
	initTimer(1000);
	asm {
		sti;
	};
	
	puts("configOS v0.1.5 prerelease\n");
	
}
