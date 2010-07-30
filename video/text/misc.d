module video.text.misc;

import video.text.text;

import kernel.io;

uint last_line = 25;

ushort curStart = 0;

extern(C) void clearScreen() { // TODO: take out extern (C)
	char* vmem = cast(char*) 0xB8000;
	
	char blank = ' ';
	
	int i;
	for(i=0; i < 80*25; i++) {
		char* loc = vmem + i;
		*loc++ = blank;
		*(loc) = getAttr();
		i++;
	}
	
	gotoXY(0,0);
	moveCursor();

}

/* Please use only scrollScreenDown() and scrollScreenUp() to scroll the
	screen, otherwise we will have a mess on our hands
*/

static void scrollScreenDown() {
	
	ushort start_addr;
	
	ubyte start_addr_low;
	ubyte start_addr_high;
	
	outb(0x3d4, 0x0c);
	io_delay();
	start_addr_high = inb(0x3d5);
	
	outb(0x3d4, 0x0d);
	io_delay();
	start_addr_low = inb(0x3d5);
	
	start_addr = curStart;
	start_addr += 80;
	
	start_addr_low = start_addr & 0xFF;
	start_addr_high = start_addr >> 8;
	
	outb(0x3d4, 0x0c);
	outb(0x3d5, start_addr_high);
	
	outb(0x3d4, 0x0d);
	outb(0x3d5, start_addr_low);
	
	last_line ++;
	curStart = start_addr;
}

static void scrollScreenUp() {
	
	ushort start_addr;
	
	ubyte start_addr_low;
	ubyte start_addr_high;
	
	if(curStart > 0) {
		start_addr = curStart;
		start_addr -= 80;
	
		start_addr_low = start_addr & 0xFF;
		start_addr_high = start_addr >> 8;
		
		outb(0x3d4, 0x0c);
		outb(0x3d5, start_addr_high);
	
		outb(0x3d4, 0x0d);
		outb(0x3d5, start_addr_low);
		last_line --;
		curStart = start_addr;
	}
}

static void toggleCursor(uint state) {
	state = ~state;
	state &= 1; // The only valid values are 1 or 0
	
	outb(0x3d4, 0x0a);
	ubyte cd = inb(0x3d5);
	
	cd |= (state << 5);
	
	outb(0x3d4, 0x0a);
	outb(0x3d5, cd);
	
}
