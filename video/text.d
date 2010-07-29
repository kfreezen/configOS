module video.text;

import kernel.io;

char* vidmem = cast(char*) 0xB8000;

struct Position {
	uint x;
	uint y;
};

struct Screen {
	ubyte attr;
	Position pos;
};

Screen screen;

static void moveCursor() {
	ushort csrLoc = screen.pos.y * 80 + screen.pos.x;
	outb(0x3d4, 14);
	outb(0x3d5, (csrLoc >> 8));
	outb(0x3d4, 15);
	outb(0x3d5, csrLoc & 0x00FF);
}

void ttyInit() {
	screen.attr = 0x07;	
	screen.pos.x = 0;
	screen.pos.y = 0;
}
void internal_putc(char character) {
	if(character == '\n') {
		screen.pos.x = 0;
		screen.pos.y ++;
	} else if(character == '\r') {
		screen.pos.x = 0;
	} else if(character == '\b' && screen.pos.x < 0) {
		screen.pos.x --;
	} else if(character == '\t') {
		screen.pos.x = (screen.pos.x + 8) & ~(8-1);
	} else if(character >= ' ') {
		char* location = vidmem + (screen.pos.y*2*80) + screen.pos.x*2;

		*location = character;
		*(location+1) = screen.attr;
		
		screen.pos.x ++;
	}
	if(screen.pos.x >= 80) {
		screen.pos.x = 0;
		screen.pos.y ++;
	}
}
void putc(char character) {
	internal_putc(character);
	moveCursor();
}

void internal_puts(char* string) {
	while(*string != '\0') {
		internal_putc(*string);
		string ++;
	}
}
void puts(char* string) {
	internal_puts(string);
	moveCursor();
}
