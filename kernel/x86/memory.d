module kernel.x86.memory;

private import video.text.text;

extern (C) uint end;

void* placementAddr = &end;

void memdebug() {
	puts("&end = ");
	printx(cast(uint) &end);
	puts("\nend = ");
	printx(cast(uint) end);
	puts("\nplacementAddr = ");
	printx(cast(uint) placementAddr);
	putc('\n');
	
}

void* kmalloc(uint size) {
	void* ret = placementAddr;
	
	placementAddr += size;
	return ret;
}

void* getPlacementAddr() {
	return placementAddr;
}

void kalignMemPtr() {
	uint tmp = cast(uint) placementAddr;
	tmp &= 0xFFFFF000;
	tmp += 0x1000;
	placementAddr = cast(void*) tmp;

}

void* kmalloc_a(uint sz) {
	kalignMemPtr();
	return kmalloc(sz);
}

void* kmalloc_p(uint sz, uint *phys) {
	if(phys != null) {
		*phys = cast(uint) placementAddr;
	}
	
	uint tmp = cast(uint) placementAddr;
	uint ptmp = cast(uint) placementAddr;
	ptmp += sz;
	placementAddr = cast(void*) ptmp;
	return cast(void*) tmp;
}
