SILENT:=@

KERNEL:=kernel.sys
# leave boot out of PROJDIRS. it needs some special processing
PROJDIRS:=kernel video runtimes misc

BOOTLOADER:=grub
BOOTDIR:=boot

COMPILER:=$(SILENT)gdc
COMPILERFLAGS:=-m32 -nostdlib -nodefaultlibs -g -c -O0

LDFLAGS:=-Tlink.ld

DFILES:=$(shell find $(PROJDIRS) -mindepth 1 -maxdepth 3 -name "*.d")
ASMFILES:=$(shell find $(PROJDIRS) -mindepth 1 -maxdepth 3 -name "*.s")

BOOTFILES:=$(shell find $(BOOTDIR)/$(BOOTLOADER) -mindepth 1 -maxdepth 3 -name "*.s")

ALLFILES:= $(BOOTFILES) $(ASMFILES) $(DFILES)

SOURCES:=$(patsubst %.s, %.o, $(BOOTFILES)) $(patsubst %.s, %.o, $(ASMFILES)) $(patsubst %.d, %.od, $(DFILES))

AS:=$(SILENT)nasm
ASFLAGS:=-felf

CURDSRC=$(patsubst %.d, %.o, $<)

all: $(SOURCES) link todolist

TODOLIST:
	-$(SILENT)rm todolist
	-@for file in $(ALLFILES); do fgrep -H -e TODO -e FIXME $$file >> todolist; done; true

clean:
	-$(SILENT)rm $(SOURCES)

link:
	@echo Object Files are $(SOURCES)
	$(SILENT)ld $(LDFLAGS) -o $(KERNEL) $(SOURCES) -melf_i386
	./refresh
	-$(SILENT)rm $(SOURCES)
	objdump -d kernel.sys > kernel.asm
%.od:%.d
	$(COMPILER) $(COMPILERFLAGS) $< -o $@
	
