module video.text;

void putLetterD() { 
	int ypos = 0; //Starting points of the cursor
	int xpos = 0;
	const uint COLUMNS = 80; //Screensize
	const uint LINES = 24;
 
	ubyte* vidmem = cast(ubyte*)0x0B8000; //Video memory address
 
	for (int i = 0; i < COLUMNS * LINES * 2; i++) { //Loops through the screen and clears it
			volatile *(vidmem + i) = 0;
	}
 
	volatile *(vidmem + (xpos + ypos * COLUMNS) * 2) = 'D' & 0xFF; //Prints the letter D
	volatile *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07; //Sets the colour for D to be light grey (0x07)
}
