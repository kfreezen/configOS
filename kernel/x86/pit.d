module kernel.pit;

import video.text.text;
import kernel.x86.isr;
import kernel.io;

uint tickLow = 0;

void initTimer(uint freq) {
	registerInterrupt(IRQ0, &timerCallback);
	
	uint div = 1193180 / freq;
	
	outb(0x43, 0x36);
	
	ubyte low = cast(ubyte) (div & 0xFF);
	ubyte high = cast(ubyte) ( (div >> 8) & 0xFF);
	
	outb(0x40, low);
	outb(0x40, high);
	
}

static void timerCallback(registers regs) {
	tickLow++;
	
	puts("Tick: ");
	printd(tickLow);
	putc('\n');;
}
