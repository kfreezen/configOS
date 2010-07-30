module kernel.x86.isr;

import video.text.text;

align(1) struct registers {
	uint ds;
	uint edi, esi, ebp, esp, ebx, edx, ecx, eax;
	uint intNo, errCode;
	uint eip, cs, eflags, useresp, ss;
};

extern (C) void isrHandler(registers regs) {
	puts("recieved interrupt: ");
	// printd(regs.intNo);
	putc('\n');
}
