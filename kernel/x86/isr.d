module kernel.x86.isr;

import video.text.text;
import kernel.io;

const int IRQ0 = 32;
const int IRQ1 = 33;
const int IRQ2 = 34;
const int IRQ3 = 35;
const int IRQ4 = 36;
const int IRQ5 = 37;
const int IRQ6 = 38;
const int IRQ7 = 39;
const int IRQ8 = 40;
const int IRQ9 = 41;
const int IRQ10 = 42;
const int IRQ11 = 43;
const int IRQ12 = 44;
const int IRQ13 = 45;
const int IRQ14 = 46;
const int IRQ15 = 47;


align(1) struct registers {
	uint ds;
	uint edi, esi, ebp, esp, ebx, edx, ecx, eax;
	uint intNo, errCode;
	uint eip, cs, eflags, useresp, ss;
};

extern (C) void isrHandler(registers regs) {
	puts("recieved interrupt: ");
	printd(regs.intNo);
	putc('\n');
}

extern (C) void irqHandler(registers regs) {
	if(regs.intNo >= 40) {
		outb(0xA0, 0x20);
	}
	
	outb(0x20, 0x20);
	
	if (intHandlers[regs.intNo] != cast(isr) 0) {
		isr handler = intHandlers[regs.intNo];
		handler(regs);
	}
}

typedef void (*isr)(registers);

isr intHandlers[256];

void registerInterrupt(ubyte n, isr handler) {
	intHandlers[n] = handler;
}
