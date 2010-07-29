[BITS 32]

I386_32		equ		0
MIPS_32		equ		4

MAGIC_NUM	equ		0x1BADB002 ; This is very irritating is the MAGIC_NUM this or 0xE85250D6
ARCH		equ		I386_32
HDR_LEN		equ		end_multiboot-multiboot

CHECKSUM	equ		-(MAGIC_NUM + ARCH + HDR_LEN)

_BYTE			equ		1
_SHORT			equ		2
_INT			equ		4
_LONG			equ		8

[section .text]

global start

extern main
extern start_ctors, end_ctors, start_dtors, end_dtors

[section .multiboot] ; I am going to fix this grub multiboot question with 4 multiboot headers
multiboot:
	dd MAGIC_NUM
	dd ARCH
	dd HDR_LEN
	dd CHECKSUM
	
mboot_info_request:
	dw 1
	dw 0
	dd end_mboot_info_request-mboot_info_request
	dd 4
	dd 5
	dd 3
end_mboot_info_request:
end_tags:
	dw 0
	dw 0
	dd 8
end_multiboot:

STACKSIZE equ 0x4000  ; 16k if you're wondering
 
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
