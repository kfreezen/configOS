module kernel.main;

import video.text;

extern(C) void main(uint magic, uint multibootAddr) {
	ttyInit();
	
	puts("Hello, world!\n");
}
