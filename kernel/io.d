module kernel.io;

static void outb(ushort port, ubyte value) {
	asm {
		mov DX, port;
		mov AL, value;
		out DX, AL;
	};
}
