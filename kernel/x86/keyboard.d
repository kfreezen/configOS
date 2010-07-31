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

// our own flags defines
const uint SHIFT = 1<<0;

/* For simplicity, all supported keyboards are in here */

ubyte* curkb;
ubyte* curkb_upper;

ubyte kbddv[128] = [
	0, 27, '1', '2', '3', '4','5','6','7','8', '9', '0', '[',']','\b','\t',
	'\'', ',', '.', 'p', 'y','f', 'g', 'c', 'r', 'l', '/', '=', '\n', 0,
	'a', 'o', 'e', 'u', 'i', 'd', 'h', 't', 'n', 's', '-', '`', 0,
	'\\', ';', 'q', 'j', 'k', 'x', 'b', 'm', 'w', 'v', 'z', 0,
	'*', 0, ' ', 0,0,0, 0,0,0, 0,0,0,0, 0,0,0, 0,0,0, '-', 0,0,0, '+', 0,0,0,
	0,0,0,0,0, 0,0,0
];
ubyte kbddv_upper[128] = [
	0, 27, '!', '@', '#', '$','%','^','&','*', '(', ')', '{','}','\b','\t',
	'\"', '<', '>', 'P', 'Y','F', 'G', 'C', 'R', 'L', '?', '+', '\n', 0,
	'A', 'O', 'E', 'U', 'I', 'D', 'H', 'T', 'N', 'S', '_', '~', 0,
	'|', ':', 'Q', 'J', 'K', 'X', 'B', 'M', 'W', 'V', 'Z', 0,
	'*', 0, ' ', 0,0,0, 0,0,0, 0,0,0,0, 0,0,0, 0,0,0, '-', 0,0,0, '+', 0,0,0,
	0,0,0,0,0, 0,0,0
];

uint flags;

ubyte keyBuffer[512];

uint keyIns = 0;
uint keyRead = 0;

bool wait = false;

void keyboardHandler(registers regs) {
	ubyte scan;
	
	scan = inb(0x60);
	
	switch(scan) {
		case 0x2A: flags |= SHIFT;
			break;
		default: break;
	}
	
	if((scan & 0x80) != 0) {
		switch(scan & ~(0x80)) {
			case 0x2A: flags &= ~SHIFT;
				break;
			default: break;
		}
	
		return;
	} else {
		if((flags & SHIFT) == 0) {
			keyBuffer[keyIns++] = curkb[scan];
		} else if((flags & SHIFT) == SHIFT) {
			keyBuffer[keyIns++] = curkb_upper[scan];
		}
		
		if(keyIns >= 512) {
			keyIns = 0;
		}
		if(keyRead >= 512) {
			keyRead = 0;
		}
	}
	
	
	if(wait == true) {
		wait = false;
	}
}

ubyte getc() {
	if(keyRead >= keyIns) {
		waitForKeyPress();
		return keyBuffer[keyRead++];
	} else {
		return keyBuffer[keyRead++];
	}
}
void waitForKeyPress() {
	wait = true;
	while(wait == true) {
	}
}

void initKeyboard() {
	curkb = kbddv.ptr; // change this to ramdisk/defaults/keyboard
	curkb_upper = kbddv_upper.ptr;
	flags = 0;
	registerInterrupt(IRQ1, &keyboardHandler);
}
