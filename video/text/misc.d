module video.text.misc;

import video.text.text;

extern(C) void clearScreen() {
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
