module video.text.text;

import kernel.io;
import video.text.misc;

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

ubyte getAttr() {
	return screen.attr;
}
void setAttr(ubyte attribute) {
	screen.attr = attribute;
}

uint getY() {
	return screen.pos.y;
}

void internal_putc(char character) {
	if(character == '\n') {
		screen.pos.x = 0;
		screen.pos.y ++;
		scroll();
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

void gotoXY(uint x, uint y) {
	screen.pos.x = 0;
	screen.pos.y = 0;
}

static void moveCursor() {
	ushort csrLoc = screen.pos.y * 80 + screen.pos.x;
	outb(0x3d4, 14);
	outb(0x3d5, (csrLoc >> 8));
	outb(0x3d4, 15);
	outb(0x3d5, csrLoc & 0x00FF);
}

void ttyInit() {
	screen.attr = 0x07;	
	clearScreen();
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

void putsln(char* string) {
	internal_puts(string);
	putc('\n');
}

void printx(uint n) {
	int temp;
	byte noZeroes = 1;
	
	puts("0x");
	
	int i;
	for(i = 28; i > 0; i -= 4) {
		temp = (n >> i) & 0xf;
		
		if(temp == 0 && noZeroes != 0) {
			continue;
		}
		if(temp >= 0xA) {
			noZeroes = 0;
			putc(temp-0xA+'A');
		} else {
			noZeroes = 0;
			putc( temp+'0');
		}
	}
	
	temp = n & 0xf;
	if (temp >= 0xa) {
		putc(temp-0xa+'A');
	} else {
		putc(temp + '0');
	}
}

void printd(uint n) {
	
	if(n == 0) {
		putc('0');
	} else {
		int acc = n;
		char[32] c1;
		int i = 0;
		
		while (acc > 0) {
			c1[i] = '0' + acc%10;
			acc /= 10;
			i++;
		}
		c1[i] = 0;
		
		char[32] c2;
		
		c2[i--] = 0;
		int j = 0;
		
		while(i >= 0) {
			c2[i--] = c1[j++];
		}
		puts(cast(char*) c2);
	}
}

