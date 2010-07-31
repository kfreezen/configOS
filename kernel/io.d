module kernel.io;

static void outb(ushort port, ubyte value) {
	asm {
		mov DX, port;
		mov AL, value;
		out DX, AL;
	};
}

static ubyte inb(ushort port) {
	ubyte returnValue;
	
	asm {
		mov DX, port;
		in AL, DX;
		mov returnValue, AL;
	};
	return returnValue;
}

static ushort inw(ushort port) {
	ushort returnValue;
	
	asm {
		mov DX, port;
		in AL, DX;
		mov AL, returnValue;
	};
	return returnValue;
}

static void io_delay() {
	int i;
	for(i = 0; i < 50; i++) {
	}
}
