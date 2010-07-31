module kernel.multiboot;

struct aout_symbol_table {
	uint tabsize;
	uint strsize;
	uint addr;
	uint reserved;
}

/* The section header table for ELF. */
struct elf_section_header_table {
	uint num;
	uint size;
	uint addr;
	uint shndx;
}

union symbol_tables {
	aout_symbol_table aout_sym;
	elf_section_header_table elf_sec;
}

struct multiboot_info {
	uint flags;
	uint mem_lower;
	uint mem_upper;
	uint boot_device;
	uint cmdline;
	uint mods_count;
	uint mods_addr;
	symbol_tables syms;
	uint mmap_length;
	uint mmap_addr;
	uint drives_length;
	uint drives_addr;
	uint config_table;
	uint boot_loader_name;
	uint apm_table;
	uint vbe_control_info;
	uint vbe_mode_info;
	ushort vbe_mode;
	ushort vbe_interface_seg;
	ushort vbe_interface_off;
	ushort vbe_interface_len;
}
