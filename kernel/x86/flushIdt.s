[global flushIdt]

flushIdt:
	mov eax, [esp + 4]
	lidt [eax]
	ret
