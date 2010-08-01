module kernel.x86.exceptions;

import video.text.text;
import video.text.misc;

import kernel.x86.isr;

void initExceptions() {
	registerInterrupt(cast(ubyte) 8, &doubleFault);
	
}

static void doubleFault(registers regs) {
	panicInit();
	
	putsln("DOUBLE_FAULT");
	
	for(;;) {} // Eventually put program save code in here
}
