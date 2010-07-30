module kernel.x86.gdt;

align(1) struct gdtEntry {
	ushort limitLow;
	ushort baseLow;
	ubyte baseMiddle;
	ubyte access;
	ubyte granularity;
	ubyte baseHigh;
};

align(1) struct gdtPtr {
	ushort limit;
	uint base;
};

gdtEntry gdtEntries[5];
gdtPtr gdtPointer;

extern (C) void flushGdt(uint gdt);

static void initGdt() {
	gdtPointer.limit = (gdtEntry.sizeof * 5) - 1;
	gdtPointer.base = cast(uint) &gdtEntries;

	gdtSet(0,0,0,0,0);
	gdtSet(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);
	gdtSet(2, 0, 0xFFFFFFFF, 0x92, 0xCF);
	gdtSet(3, 0, 0xFFFFFFFF, 0xFA, 0xCF);
	gdtSet(4, 0, 0xFFFFFFFF, 0xF2, 0xCF);
	
	flushGdt(cast(uint) &gdtPointer);
}

static void gdtSet(int num, uint base, uint limit, ubyte access, ubyte gran) {
	gdtEntries[num].baseLow = (base & 0xFFFF);
	gdtEntries[num].baseMiddle = (base >> 16) & 0xFF;
	gdtEntries[num].baseHigh = (base >> 24) & 0xFF;
	
	gdtEntries[num].limitLow = (limit & 0xFFFF);
	gdtEntries[num].granularity = (limit >> 16) & 0x0f;
	
	gdtEntries[num].granularity |= gran & 0xF0;
	gdtEntries[num].access = access;
}
