module kernel.x86.paging;

extern (C) uint end;

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
		mov CR3, EAX;
		
		mov EAX, CR0;
		or EAX, 0x80000000;
		mov CR0, EAX;
	};
}
