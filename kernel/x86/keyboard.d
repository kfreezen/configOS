module kernel.x86.keyboard;

import kernel.x86.isr;
import kernel.io;
import video.text.text;
import kernel.x86.pit;

const byte KEYS_30 = 0;
const byte KEYS_24 = 2;

const byte PAUSE_250 = 0;
const byte PAUSE_500 = 1<<5;
const byte PAUSE_750 = 2<<5;
const byte PAUSE_1000 = 3<<5;

/* For simplicity, all supported keyboards are in here */

ubyte* curkb = kbddv.ptr;

ubyte kbddv[128] = [
	0, 27, '1', '2', '3', '4','5','6','7','8', '9', '0', '[',']','\b','\t',
	'\'', ',', '.', 'p', 'y','f', 'g', 'c', 'r', 'l', '/', '=', '\n', 0,
	'a', 'o', 'e', 'u', 'i', 'd', 'h', 't', 'n', 's', '-', '`', 0,
	'\\', ';', 'q', 'j', 'k', 'x', 'b', 'm', 'w', 'v', 'z', 0,
	'*', 0, ' ', 0,0,0, 0,0,0, 0,0,0,0, 0,0,0, 0,0,0, '-', 0,0,0, '+', 0,0,0,
	0,0,0,0,0, 0,0,0
];

ubyte keybuffer[512];

uint keyIns = 0;
uint keyRead = 0;

bool wait = false;

uint current = 0;

void keyboardHandler(registers regs) {
	ubyte scan;
	
	scan = inb(0x60);
	
	if(scan & 0x80 == 0x80) { return; }
	else {
		keybuffer[keyIns++] = curkb[scan];
		
		puts("Keyboard event!... ");
		printd(current);
		putc('\n');
		
		putc(curkb[scan]);
	}
	if(wait == true) {
		wait = false;
	}
	current++;
}

void waitForKeyPress() {
	wait = true;
	while(wait == true) {
	}
}

void initKeyboard() {
	registerInterrupt(IRQ1, &keyboardHandler);
}
