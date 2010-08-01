module kernel.x86.floppy;

import kernel.x86.isr;
import kernel.io;
import kernel.multiboot;
import kernel.x86.pit;

bool floppyIRQ = false;

ubyte currentDrive = 0;

const ushort FLOPPY_DOR = 0x3F2;
const ushort FLOPPY_MSR = 0x3F4;
const ushort FLOPPY_FIFO = 0x3f5;
const ushort FLOPPY_CTRL = 0x3f7;

const ubyte FLOPPY_DOR_DRIVE0 = 0;
const ubyte FLOPPY_DOR_DRIVE1 = 1;
const ubyte FLOPPY_DOR_DRIVE2 = 2;
const ubyte FLOPPY_DOR_DRIVE3 = 3;
const ubyte FLOPPY_DOR_RESET = 4;
const ubyte FLOPPY_DOR_DMA = 8;
const ubyte FLOPPY_DOR_DRIVE0_MOTOR = 16;
const ubyte FLOPPY_DOR_DRIVE1_MOTOR = 32;
const ubyte FLOPPY_DOR_DRIVE2_MOTOR = 64;
const ubyte FLOPPY_DOR_DRIVE3_MOTOR = 128;

const ubyte FLOPPY_MSR_DRIVE1_BUSY = 1;
const ubyte FLOPPY_MSR_DRIVE2_BUSY = 2;
const ubyte FLOPPY_MSR_DRIVE3_BUSY = 4;
const ubyte FLOPPY_MSR_DRIVE4_BUSY = 8;
const ubyte FLOPPY_MSR_BUSY = 16;
const ubyte FLOPPY_MSR_DMA = 32;
const ubyte FLOPPY_MSR_DATAIO = 64;
const ubyte FLOPPY_MSR_DATAREG = 128;

const ubyte FDC_READ_TRACK = 2;
const ubyte FDC_SPECIFY = 3;
const ubyte FDC_CHECK_STAT = 4;
const ubyte FDC_WRITE_SECT = 5;
const ubyte FDC_READ_SECT = 6;
const ubyte FDC_CALIBRATE = 7;
const ubyte FDC_CHECK_INT = 8;
const ubyte FDC_WRITE_DEL_S = 9;
const ubyte FDC_READ_ID_S = 0xa;
const ubyte FDC_READ_DEL_S = 0xc;
const ubyte FDC_FORMAT_TRACK = 0xd;
const ubyte FDC_SEEK = 0x0f;

const ubyte FDC_EXT_SKIP = 0x20;
const ubyte FDC_EXT_DENSITY = 0x40;
const ubyte FDC_EXT_MULTITRACK = 0x80;

const ubyte FLOPPY_GAP3_LEN_STD = 42;
const ubyte FLOPPY_GAP3_LEN_5_14 = 32;
const ubyte FLOPPY_GAP3_LEN_3_5 = 27;

const ubyte FLOPPY_SECTOR_128 = 0;
const ubyte FLOPPY_SECTOR_256 = 1;
const ubyte FLOPPY_SECTOR_512 = 2;
const ubyte FLOPPY_SECTOR_1024 = 4;

const int DMA_BUFFER = 0x1000;

const ubyte FLOPPY_SECTORS_PER_TRACK = 18;

void initFloppy() {
	currentDrive = 4;
	registerInterrupt(cast(ubyte) IRQ6, &floppyCallback);
	
	floppyInitDma();
	floppyReset();
	floppyDriveData(13, 1, 0xf, true);
	
}

void floppyCallback(registers regs) {
	if(floppyIRQ == false) {
		floppyIRQ = true;
	}
}

void floppyWait() {
	while(floppyIRQ == false) {
		if(floppyIRQ) {
			break;
		}
	}
	
	floppyIRQ = false;
}

void floppyInitDma() {
	outb(0x0a, 0x06);
	outb(0xd8, 0xFF);
	outb(0x04, 0);
	outb(0x04, 0x10);
	outb(0xd8, 0xff);
	outb(0xd8, 0xff);
	outb(0x05, 0xff);
	outb(0x05, 0x23);
	outb(0x80, 0);
	outb(0x0a, 0x02);
	
}
void floppyDmaRead() {
	outb(0x0a, 0x06);
	outb(0x0b, 0x56);
	outb(0x0a, 0x02);
}

void floppyDmaWrite() {
	outb(0x0a, 0x06);
	outb(0x0b, 0x5a);
	outb(0x0a, 0x02);
}

void floppyWriteDor(ubyte value) {
	outb(FLOPPY_DOR, value);
}

ubyte floppyReadStatus() {
	return inb(FLOPPY_MSR);
}

void floppySendCmd(ubyte cmd) {
	int i;
	for(i = 0; i < 500; i++) {
		if( floppyReadStatus() & FLOPPY_MSR_DATAREG) {
			outb(FLOPPY_FIFO, cmd);
			return;
		}
	}
}

ubyte floppyReadData() {
	int i;
	for(i = 0; i < 500; i++) {
		if( floppyReadStatus() & FLOPPY_MSR_DATAREG) {
			return inb(FLOPPY_FIFO);
		}
		
	}
}

void floppyWriteCcr(ubyte value) {
	outb(FLOPPY_CTRL, value);
}

void floppyCheckInt( uint* st0, uint* cyl) {
	floppySendCmd(FDC_CHECK_INT);
	*st0 = floppyReadData();
	*cyl = floppyReadData();
}

void floppyReadSectorImp(ubyte head, ubyte track, ubyte sector) {
	uint st0, cyl;
	
	floppyDmaRead();
	
	floppySendCmd(FDC_READ_SECT | FDC_EXT_MULTITRACK | FDC_EXT_SKIP | FDC_EXT_DENSITY);
	floppySendCmd(head << 2 | currentDrive);
	floppySendCmd(track);
	floppySendCmd(head);
	floppySendCmd(sector);
	floppySendCmd(FLOPPY_SECTOR_512);
	floppySendCmd( ( ( sector + 1) >= FLOPPY_SECTORS_PER_TRACK ) ? FLOPPY_SECTORS_PER_TRACK : sector + 1 );
	floppySendCmd(FLOPPY_GAP3_LEN_3_5);
	floppySendCmd(0xff);
	
	floppyWait();
	
	int j;
	for (j = 0; j < 7; j++) {
		floppyReadData();
	}
	
	floppyCheckInt(&st0, &cyl);
}

void floppyDriveData(uint stepr, uint loadt, uint unloadt, bool dma ) {
	uint data = 0;
	
	floppySendCmd(FDC_SPECIFY);
	
	data = ( (stepr & 0xf) << 4) | (unloadt & 0xf);
	floppySendCmd(data);
	
	data = (loadt) << 1 | (dma==true) ? 1 : 0;
	floppySendCmd(data);
}

int floppyCalibrate(uint drive) {
	uint st0, cyl;
	
	floppyControlMotor(true);
	
	for(int i = 0; i < 10; i++) {
		floppySendCmd(FDC_CALIBRATE);
		floppySendCmd(drive);
		
		floppyWait();
		floppyCheckInt(&st0, &cyl);
		
		if(cyl == 0) {
			floppyControlMotor(false);
			return 0;
		}
	}
	
	floppyControlMotor(false);
	return -1;
}

int floppySeek(uint cyl, uint head) {
	uint st0, cyl0;
	
	for(int i= 0; i < 10; i++) {
		floppySendCmd(FDC_SEEK);
		floppySendCmd( (head) << 2 | currentDrive);
		floppySendCmd(cyl);
		
		floppyWait();
		
		floppyCheckInt(&st0, &cyl0);
		
		if(cyl0 == cyl) {
			return 0;
		}
	}
	
	return -1;
}

void floppyDisable() {
	floppyWriteDor(0);
}

void floppyEnable() {
	floppyWriteDor(FLOPPY_DOR_RESET | FLOPPY_DOR_DMA);
}

void floppyReset() {
	uint st0, cyl;
	
	floppyDisable();
	floppyEnable();

	floppyWait();
	
	int i;
	for(i = 0; i < 4; i++) {
		floppyCheckInt(&st0, &cyl);
	}
	
	floppyWriteCcr(0);
	
	floppyDriveData(3u,16u,240u, true);
	
	floppyCalibrate(currentDrive);
	
}

void lbaToChs(int lba, int* head, int* track, int* sector) {
	*head = ( lba % ( FLOPPY_SECTORS_PER_TRACK * 2 ) ) / ( FLOPPY_SECTORS_PER_TRACK );
	*track = lba / (FLOPPY_SECTORS_PER_TRACK * 2);
	*sector = lba % FLOPPY_SECTORS_PER_TRACK + 1;
}

void floppyControlMotor(bool b) {
	if(currentDrive > 3) {
		return;
	}
	
	uint motor = 0;
	
	switch(currentDrive) {
		case 0: motor = FLOPPY_DOR_DRIVE0_MOTOR;
			break;
		case 1: motor = FLOPPY_DOR_DRIVE1_MOTOR;
			break;
		case 2: motor = FLOPPY_DOR_DRIVE2_MOTOR;
			break;
		case 3: motor = FLOPPY_DOR_DRIVE3_MOTOR;
			break;
	}
	
	if (b) {
		floppyWriteDor(currentDrive | motor | FLOPPY_DOR_RESET | FLOPPY_DOR_DMA);
	} else {
		floppyWriteDor(FLOPPY_DOR_RESET);
	}
	
	sleep(20);
}

ubyte* floppyReadSector(int sectorLBA) {
	
	int head=0;
	int track = 0;
	int sector = 1;
	
	lbaToChs(sectorLBA, &head, &track, &sector);
	
	floppyControlMotor(true);
	
	if(floppySeek(track, head) != 0) {
		return null;
	}
	floppyReadSectorImp(head, track, sector);
	floppyControlMotor(false);
	
	return cast(ubyte*) DMA_BUFFER;
}
