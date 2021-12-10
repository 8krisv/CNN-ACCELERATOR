#include <stdio.h>

#ifdef _JTAG_UART_BASE 

size_t write( int fd, const void* buf, size_t nbytes ) {
	int i ;
	const char* cbuf = (const char*) buf ;
	for( i = 0 ; i < nbytes ; ++i ) {
		while( (__builtin_ldwio( (void*) (_JTAG_UART_BASE+4) ) & 0xffff0000) == 0 ) ;
		__builtin_stwio( (void*) (_JTAG_UART_BASE), *cbuf++ ) ;
	}

	return nbytes;
}

size_t read( int fd, void* buf, size_t nbytes ) {
	int i, data ;
	char* cbuf = (char*) buf ;

	do {
		data = __builtin_ldwio( (void*) (_JTAG_UART_BASE) ) ;
	} while( (data & (1 << 15)) == 0 ) ;

	int charsAvailable = (data >> 16) + 1 ;
	int charsToRead = nbytes < charsAvailable ? nbytes : charsAvailable ;
	
	for( i = 0 ; i < charsToRead ; ++i ) {
		*cbuf++ = (char) (data & 0xff) ;
		data = __builtin_ldwio( (void*) (_JTAG_UART_BASE) ) ;
	}

	return charsToRead ;
}

#endif
