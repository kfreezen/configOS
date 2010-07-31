
MBOOT_PAGE_ALIGN	equ	1<<0
MBOOT_MEM_INFO		equ	1<<1
MBOOT_HEADER_MAGIC	equ 0x1BADB002

MBOOT_HEADER_FLAGS	equ	MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM		equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

[BITS 32]

[section .text]

[GLOBAL mboot]
[EXTERN code]
[EXTERN bss]
[EXTERN end]

STACKSIZE equ 0x4000

mboot:
	dd	MBOOT_HEADER_MAGIC
	
	dd	MBOOT_HEADER_FLAGS
	dd 	MBOOT_CHECKSUM
	
	dd	mboot
	dd	code
	dd	bss
	dd	end
	dd 	start
	
[GLOBAL start]
[EXTERN main]
extern start_ctors, end_ctors, start_dtors, end_dtors

static_ctors_loop:
   mov ebx, start_ctors
   jmp .test
.body:
   call [ebx]
   add ebx,4
.test:
   cmp ebx, end_ctors
   jb .body
 
start:
	   cli
       mov esp, STACKSIZE+stack
 
       push eax
       push ebx
 
       call main
 
static_dtors_loop:
   mov ebx, start_dtors
   jmp .test
.body:
   call [ebx]
   add ebx,4
.test:
   cmp ebx, end_dtors
   jb .body
 
 
cpuhalt:
       hlt
       jmp cpuhalt
 
section .bss
align 32
 
stack:
      resb      STACKSIZE
