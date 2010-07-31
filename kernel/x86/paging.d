module kernel.x86.paging;

import kernel.x86.isr;
import kernel.x86.memory;
import kernel.multiboot;

<<<<<<< HEAD
uint page_aligned_end;

uint* pageDir;

/* Paging prototype */

static void initPaging() {
	pageDir = cast(uint*) page_aligned_end;
	initPageDir();
}

static void initPageDir() {
	uint i = 0;
	for(i = 0; i < 1024; i++) {
		pageDir[i] = 0 | 2;
	}
	
	uint* firstPageTable = pageDir + 0x1000;
	
	uint address = 0;
	
	for(i = 0; i < 1024; i++) {
		firstPageTable[i] = address | 3;
		address = address + 0x1000;
	}
	
	pageDir[0] = cast(uint) firstPageTable;
	pageDir[0] |= 3;
	
	asm {
		mov EAX, pageDir;
=======
import misc.common;

import video.text.text;
import video.text.misc;

const uint PRESENT = 1<<0;
const uint READ_WRITE = 1<<1;
const uint USER_PAGE = 1<<2;

extern (C) multiboot_info* multiboot;

typedef uint page;

struct pageTable {
	uint pages[1024];
};

uint* kernelDir;
pageTable* tables;
uint nframes = 8; // one frame equals 4 MiB
void initPaging() {
	asm {
		cli;
	};
	
	kernelDir = cast(uint*) kmalloc_a(0x1000);
	tables = cast(pageTable*) kmalloc_a(pageTable.sizeof*1024);
	
	uint addr = 0;
	
	uint i;
	uint j;
	for(j = 0; j < nframes; j++) {
		for(i = 0; i < 1024; i++) { // for now we map just the first 4 MiB of memory
			tables[j].pages[i] = addr | 3;
			addr += 0x1000;
		}
	}
	kernelDir[0] = cast(uint) tables;
	kernelDir[0] = kernelDir[0] | 3;
	
	for(i = 1; i < 1024; i++) {
		kernelDir[i] = 0 | 2;
	}
	
	registerInterrupt(cast(ubyte) 14, &pageFault);
	
	asm {
		mov EAX, kernelDir;
>>>>>>> cfgos/work
		mov CR3, EAX;
		
		mov EAX, CR0;
		or EAX, 0x80000000;
		mov CR0, EAX;
<<<<<<< HEAD
	};
=======
		sti;
	};
	putsln("Enabled paging!");
}
void pageFault(registers regs) {
	uint faultingAddr;
	
	uint present;
	uint rw;
	uint us;
	uint reserved;
	uint id;
	
	asm {
		mov EAX, CR2;
		mov faultingAddr, EAX;
	};
	
	panicInit();
	
	present = !(regs.errCode & 1);
	rw = regs.errCode & 2;
	us = regs.errCode & 4;
	reserved = regs.errCode & 8;
	id = regs.errCode & 0x10;
	
	puts("PAGE_FAULT: ");
	printx(faultingAddr);
	putc('\n');
	if (present) putsln("PAGE_NOT_PRESENT");
	if (rw) putsln("PAGE_WRITTEN_TO_WHEN_NOT_WRITEABLE");
	if (us) putsln("PROCESSOR_WRITING_TO_KERNEL_PAGE_WHEN_IN_USER_MODE");
	if (reserved) putsln("RESERVED_BITS_OF_PAGE_ENTRY_WRITTEN_TO");
	
	for(;;) {
	}
>>>>>>> cfgos/work
}
