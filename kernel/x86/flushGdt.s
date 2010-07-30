[section .text]

[global flushGdt]

flushGdt:
	enter 0,0
	mov eax, [ebp + 8]
	
	lgdt [EAX];
		
	mov AX, 0x10;
	mov DS, AX;
	mov ES, AX;
	mov FS, AX;
	mov GS, AX;
	mov SS, AX;
		
	jmp 0x08:flush;
	
	flush: ;
		leave
		ret
