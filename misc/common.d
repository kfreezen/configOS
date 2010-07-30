
static void memset(void* pointer, ubyte value, uint num) {
	ubyte* ptr = cast(ubyte*) pointer;
	
	while(num-- != 0) {
		*ptr++ = value;
	}
	
}
