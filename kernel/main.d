module kernel.main;

import video.text.text;
import video.text.misc;

import kernel.x86.gdt;
import kernel.x86.idt;


extern(C) void main(uint magic, uint multibootAddr) {
	initGdt();
	initIdt();
	
	ttyInit();
	
	puts("Hello, world!\n");
	puts("Hello, world!\n");
	
	asm {
		int 0x4;
	};
}
