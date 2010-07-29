module kernel.main;

import video.text.text;
import video.text.misc;

char* vmem = cast(char*)0xb8000;

extern(C) void main(uint magic, uint multibootAddr) {
	ttyInit();
	
	puts("Hello, world!\n");
}
