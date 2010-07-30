module kernel.x86.paging;

extern (C) uint end;

uint page_aligned_end = (&end & 0xFFFFF000) + 0x1000;

uint* pageDir = cast(uint*) page_aligned_end;
uint* pageTable = pageDir + 0x1000;

static void initPageDir() {
	int i = 0;
	for(i = 0; i < 1024; i++) {
		pageDir[i] = 0 | 2;
	}
	
	// FINISH THIS OUT!
}
