module kernel.pit;

import video.text.text;
import kernel.x86.isr;
import kernel.io;

uint tickLow = 0;
uint seconds = 0;

void initTimer(uint freq) {
	registerInterrupt(IRQ0, &timerCallback);
	
	uint div = 1193180 / freq;
	
	outb(0x43, 0x36);
	
	ubyte low = cast(ubyte) (div & 0xFF);
	ubyte high = cast(ubyte) ( (div >> 8) & 0xFF);
	
	outb(0x40, low);
	outb(0x40, high);
	frq = freq;
}

uint frq;

uint sleep_time = 0;

void sleep(uint ticks) {
	sleep_time = ticks;
	while(sleep_time != 0) {
	}
}

static void timerCallback(registers regs) {
	tickLow++;
	
	if(tickLow % 50 == 0) {
		seconds++;
	}
	if(sleep_time != 0) {
		sleep_time--;
	}
}
