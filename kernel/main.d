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

	fakieConsole();
}

char buffer[512];

public static void fakieConsole() {
	while(1) {
		puts(">>>");
		getline();
	
		if(!strcmp(buffer.ptr, "hello")) {
			putsln("Hello, osdev from console!");
		}
	}
}

void getline() {
	ubyte c;
	uint i;
	
	while((c = getc()) != '\n') {
		if(c == '\b' && i != 0) {
			buffer[i--] = 0;
			putc('\b');
		} else if(c >= ' ') {
			buffer[i++] = c;
			putc(c);
		}
	}
	putc('\n');
	buffer[i] = 0;
}

int strcmp (char * s1, char * s2)
{
    for(; *s1 == *s2; ++s1, ++s2)
        if(*s1 == 0)
            return 0;
    return (cast(ubyte*) s1 < cast(ubyte*) s2) ? -1 : 1;
}
