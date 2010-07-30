module kernel.x86.idt;

import misc.common;

align(1) struct idtEntry {
	ushort baseLow;
	ushort segmentSel;
	ubyte always0;
	ubyte flags;
	ushort baseHigh;
};

align(1) struct idtPtr {
	ushort limit;
	uint base;
};

extern (C) void isr0 ();
extern (C) void isr1 ();
extern (C) void isr2 ();
extern (C) void isr3 ();
extern (C) void isr4 ();
extern (C) void isr5 ();
extern (C) void isr6 ();
extern (C) void isr7 ();
extern (C) void isr8 ();
extern (C) void isr9 ();
extern (C) void isr10();
extern (C) void isr11();
extern (C) void isr12();
extern (C) void isr13();
extern (C) void isr14();
extern (C) void isr15();
extern (C) void isr16();
extern (C) void isr17();
extern (C) void isr18();
extern (C) void isr19();
extern (C) void isr20();
extern (C) void isr21();
extern (C) void isr22();
extern (C) void isr23();
extern (C) void isr24();
extern (C) void isr25();
extern (C) void isr26();
extern (C) void isr27();
extern (C) void isr28();
extern (C) void isr29();
extern (C) void isr30();
extern (C) void isr31();

extern (C) void flushIdt(uint idtr);

idtEntry idtEntries[256];
idtPtr idtPointer;

static void initIdt() {
	idtPointer.limit = (idtEntry.sizeof * 256) - 1;
	idtPointer.base = cast(uint) &idtEntries;
	
	memset(&idtEntries, 0, idtEntry.sizeof*256);
	
	idtSet(0 , cast(uint) &isr0 , 0x08, 0x8e);
	idtSet(1 , cast(uint) &isr1 , 0x08, 0x8e);
	idtSet(2 , cast(uint) &isr2 , 0x08, 0x8e);
	idtSet(3 , cast(uint) &isr3 , 0x08, 0x8e);
	idtSet(4 , cast(uint) &isr4 , 0x08, 0x8e);
	idtSet(5 , cast(uint) &isr5 , 0x08, 0x8e);
	idtSet(6 , cast(uint) &isr6 , 0x08, 0x8e);
	idtSet(7 , cast(uint) &isr7 , 0x08, 0x8e);
	idtSet(8 , cast(uint) &isr8 , 0x08, 0x8e);
	idtSet(9 , cast(uint) &isr9 , 0x08, 0x8e);
	idtSet(10, cast(uint) &isr10, 0x08, 0x8e);
	idtSet(11, cast(uint) &isr11, 0x08, 0x8e);
	idtSet(12, cast(uint) &isr12, 0x08, 0x8e);
	idtSet(13, cast(uint) &isr13, 0x08, 0x8e);
	idtSet(14, cast(uint) &isr14, 0x08, 0x8e);
	idtSet(15, cast(uint) &isr15, 0x08, 0x8e);
	idtSet(16, cast(uint) &isr16, 0x08, 0x8e);
	idtSet(17, cast(uint) &isr17, 0x08, 0x8e);
	idtSet(18, cast(uint) &isr18, 0x08, 0x8e);
	idtSet(19, cast(uint) &isr19, 0x08, 0x8e);
	idtSet(20, cast(uint) &isr20, 0x08, 0x8e);
	idtSet(21, cast(uint) &isr21, 0x08, 0x8e);
	idtSet(22, cast(uint) &isr22, 0x08, 0x8e);
	idtSet(23, cast(uint) &isr23, 0x08, 0x8e);
	idtSet(24, cast(uint) &isr24, 0x08, 0x8e);
	idtSet(25, cast(uint) &isr25, 0x08, 0x8e);
	idtSet(26, cast(uint) &isr26, 0x08, 0x8e);
	idtSet(27, cast(uint) &isr27, 0x08, 0x8e);
	idtSet(28, cast(uint) &isr28, 0x08, 0x8e);
	idtSet(29, cast(uint) &isr29, 0x08, 0x8e);
	idtSet(30, cast(uint) &isr30, 0x08, 0x8e);
	idtSet(31, cast(uint) &isr31, 0x08, 0x8e);
	
	flushIdt(cast(uint) &idtPointer);
}

static void idtSet(ubyte num, uint base, ushort sel, ubyte flags) {
	idtEntries[num].baseLow = base & 0xFFFF;
	idtEntries[num].baseHigh = (base >> 16) & 0xFFFF;
	
	idtEntries[num].segmentSel = sel;
	idtEntries[num].always0 = 0;
	
	idtEntries[num].flags = flags;
}
