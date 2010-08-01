module kernel.x86.paging;

import kernel.x86.isr;
import kernel.x86.memory;
import kernel.multiboot;
import misc.common;

import video.text.text;
import video.text.misc;
import kernel.panic;

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
uint nframes; // one frame equals 4 MiB - set by initPaging when called
/* Bitset implementation */
/**
	allocFrame(pid) : This allocates 4 MiB to a program
	freeFrame(frame, pid) : This frees 4 MiB if it is used by pid
	freeAll(pid) : free all frames used by pid
	firstFreeFrame() : finds the first free frame
**/

const ushort ALLOCATED = 1<<15;
const ushort PID = 0b0000000111111111;
const uint ERROR = 0xFFFFFFFF;

ushort* bitset;
/*
	frame overview layout:
		15: Allocated
		10-14: reserved
		0-9: PID of process using frame, if Allocated is 0, ignore this
*/

const bool DEALLOCATED = true;
const bool NO_DEALLOCATION = false;

void freeAll(ushort pid) {
	int i;
	for(i = 0; i < nframes; i++) {
		if((bitset[i] & PID) == pid) {
			freeFrame(i, pid);
		}
	}
}

bool freeFrame(uint frame,ushort pid) {
	if((frame & PID) == pid) {
		frame &= ~(PID | ALLOCATED);
		return DEALLOCATED;
	} else {
		return NO_DEALLOCATION;
	}
}

uint allocFrame(ushort pid) {
	uint frame = firstFreeFrame();
	if(frame == ERROR) {
		panic("No frames available!");
	} else {
		frame |= ALLOCATED;
		frame &= ~(PID);
		frame |= pid;
		return frame;
	}
}

uint firstFreeFrame() {
	int i;
	for(i = 0; i < nframes; i++) {
		if((bitset[i] & ALLOCATED) == 0) {
			// we found ourselves a free frame
			return i;
		}
	}
	// No free frames were available, return ERROR
	return ERROR;
}

void initVirtualMemoryManager() {
	bitset = cast(ushort*) kmalloc_a(nframes*ushort.sizeof);
	
}



/* Paging */
void initPaging(uint sizeOfMemInMB) {
	asm {
		cli;
	};
	
	nframes = sizeOfMemInMB / 4;
	
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
		mov CR3, EAX;
		
		mov EAX, CR0;
		or EAX, 0x80000000;
		mov CR0, EAX;
		sti;
	};
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
}
