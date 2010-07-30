module kernel.x86.idt;

import misc.common;
import kernel.io;

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
extern (C) void isr32();
extern (C) void isr33();
extern (C) void isr34();
extern (C) void isr35();
extern (C) void isr36();
extern (C) void isr37();
extern (C) void isr38();
extern (C) void isr39();
extern (C) void isr40();
extern (C) void isr41();
extern (C) void isr42();
extern (C) void isr43();
extern (C) void isr44();
extern (C) void isr45();
extern (C) void isr46();
extern (C) void isr47();

extern (C) void flushIdt(uint idtr);

idtEntry idtEntries[256];
idtPtr idtPointer;

static void initIdt() {

	outb(0x20, 0x11);
  	outb(0xA0, 0x11);
  	outb(0x21, 0x20);
  	outb(0xA1, 0x28);
  	outb(0x21, 0x04);
  	outb(0xA1, 0x02);
  	outb(0x21, 0x01);
  	outb(0xA1, 0x01);
  	outb(0x21, 0x0);
  	outb(0xA1, 0x0);
  	
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
	idtSet(32, cast(uint) &isr32, 0x08, 0x8e);
	idtSet(33, cast(uint) &isr33, 0x08, 0x8e);
	idtSet(34, cast(uint) &isr34, 0x08, 0x8e);
	idtSet(35, cast(uint) &isr35, 0x08, 0x8e);
	idtSet(36, cast(uint) &isr36, 0x08, 0x8e);
	idtSet(37, cast(uint) &isr37, 0x08, 0x8e);
	idtSet(38, cast(uint) &isr38, 0x08, 0x8e);
	idtSet(39, cast(uint) &isr39, 0x08, 0x8e);
	idtSet(40, cast(uint) &isr40, 0x08, 0x8e);
	idtSet(41, cast(uint) &isr41, 0x08, 0x8e);
	idtSet(42, cast(uint) &isr42, 0x08, 0x8e);
	idtSet(43, cast(uint) &isr43, 0x08, 0x8e);
	idtSet(44, cast(uint) &isr44, 0x08, 0x8e);
	idtSet(45, cast(uint) &isr45, 0x08, 0x8e);
	idtSet(46, cast(uint) &isr46, 0x08, 0x8e);
	idtSet(47, cast(uint) &isr47, 0x08, 0x8e);

	flushIdt(cast(uint) &idtPointer);
}

static void idtSet(ubyte num, uint base, ushort sel, ubyte flags) {
	idtEntries[num].baseLow = base & 0xFFFF;
	idtEntries[num].baseHigh = (base >> 16) & 0xFFFF;
	
	idtEntries[num].segmentSel = sel;
	idtEntries[num].always0 = 0;
	
	idtEntries[num].flags = flags;
}
