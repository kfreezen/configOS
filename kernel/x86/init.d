module kernel.init;

import kernel.multiboot;
private import kernel.x86.gdt;
private import kernel.x86.idt;
private import kernel.x86.paging;
import video.text.text;
import video.text.misc;
import kernel.x86.keyboard;
private import kernel.x86.pit;
private import kernel.x86.exceptions;
private import kernel.x86.floppy;

multiboot_info* multibootStruct;

extern(C) void init(uint magic, multiboot_info* multiboot) {
	multibootStruct = multiboot;
	
	ttyInit();
	
	initGdt();
	initIdt();
	initPaging(multibootStruct.mem_upper / 1024);
	
	asm {
		sti;
	};
	
	initKeyboard();
	initTimer(50);
	initExceptions();
	
	asm {
		sti;
	};
	
	initFloppy();
	
	multiboot = multibootStruct;
	
}

void infoNum(char* str, uint n, bool hex) {
	puts(str);
	puts(": ");
	if(hex == true) {
		printx(n);
	} else {
		printd(n);
	}
	
	putc('\n');
}

void infoStr(char* str, char* str2) {
	puts(str);
	puts(": ");
	putsln(str2);
}

char* bootdevice[4] = [
	"FDD 0",
	"FDD 1",
	"FDD 2",
	"FDD 3"
];

void displaySystemInfo() {
	infoNum("System memory in MiB", multibootStruct.mem_upper / 1024, false);
	infoNum("Boot device", multibootStruct.boot_device, false);
	infoNum("debug BOOTDEV", multibootStruct.flags & BOOTDEV, true);
	putsln("");
}
