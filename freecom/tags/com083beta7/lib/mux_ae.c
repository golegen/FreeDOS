/*	$id$
	$Locker$	$Name$	$State$

	Implementation for Installable COMMAND extensions (MUX-AE)

	This file bases on MUX_AE.C of FreeCOM v0.81 beta 1.

	$Log$
	Revision 1.1  2001/04/12 00:33:53  skaus
	chg: new structure
	chg: If DEBUG enabled, no available commands are displayed on startup
	fix: PTCHSIZE also patches min extra size to force to have this amount
	   of memory available on start
	bugfix: CALL doesn't reset options
	add: PTCHSIZE to patch heap size
	add: VSPAWN, /SWAP switch, .SWP resource handling
	bugfix: COMMAND.COM A:\
	bugfix: CALL: if swapOnExec == ERROR, no change of swapOnExec allowed
	add: command MEMORY
	bugfix: runExtension(): destroys command[-2]
	add: clean.bat
	add: localized CRITER strings
	chg: use LNG files for hard-coded strings (hangForEver(), init.c)
		via STRINGS.LIB
	add: DEL.C, COPY.C, CBREAK.C: STRINGS-based prompts
	add: fixstrs.c: prompts & symbolic keys
	add: fixstrs.c: backslash escape sequences
	add: version IDs to DEFAULT.LNG and validation to FIXSTRS.C
	chg: splitted code apart into LIB\*.c and CMD\*.c
	bugfix: IF is now using error system & STRINGS to report errors
	add: CALL: /N

 */

#include "../config.h"

#include <assert.h>
#include <ctype.h>
#include <dos.h>
#include <string.h>

#include "../include/command.h"
#include "../include/crossjmp.h"
#include "../include/mux_ae.h"

#if BUFFER_SIZE_MUX_AE > 255
#error "BUFFER_SIZE_MUX_AE must not exceed 255"
#endif

/* Check for extensions and perform it, on success return != 0 */
/* Also: The contents of both buffers is monitored in order to
	check if they got overflowed during the MUX call. If so,
	the executation is aborted. */
int runExtension(char * const command, char * const line)
{	int clen, llen;
	struct REGPACK r;
	char *p;

	assert(command);
	assert(line);

	assert(strlen(command) < BUFFER_SIZE_MUX_AE);
	assert(strlen(line) <= BUFFER_SIZE_MUX_AE);

	assert(FP_SEG(command) == FP_SEG(line));

	/* Fill the length bytes */
	command[-1] = (char)(clen = strlen(command));
	line[-1]    = (char)(llen = strlen(line));
	command[-2] = line[-2] = (char)BUFFER_SIZE_MUX_AE;

	/* 4dos v4 compatible space padding */
	memset(command + clen, ' ', BUFFER_SIZE_MUX_AE - clen);
	/* The command line is \xd terminated, for savety reasons an \0 is
		added too */
	strcat(line + llen, "\xd");
	line[BUFFER_SIZE_MUX_AE] = '\0';

/* Both strings have been prepared now; the MUX call is going to happen */
	r.r_ax = 0xae00;		/* Installable Commands check for extension */
	r.r_dx = 0xffff;		/* Magic value */
	r.r_cx = -llen;			/* length of command line tail (4dos v4) */
	r.r_ds = r.r_es = FP_SEG(command);
	r.r_bx = FP_OFF(line) - 2;
	r.r_si = FP_OFF(command) - 1;
	r.r_di = 0;				/* Magic value 4dos v4 */

	intr(0x2f, &r);

	switch(r.r_ax & 0xFF) {
	case 0x00:		/* No appropriate extension found */
		break;

	default:		/* Invalid response */
		dprintf( ("[Invalid response from Installable Commands handler: 0x%02x]\n", r.r_ax & 0xFF) );
		break;

	case 0xFF:		/* Is an extension -> execute the Installable Command */
		r.r_ax = 0xae01;
		intr(0x2f, &r);
		if(command[-1] == 0)		/* The command had been processed */
			return 1;				/* Stop interpreting the command */

		break;
	}

/* Cleanup: Adjust buffers and check for overflow */
	if((unsigned char)line[-2] != BUFFER_SIZE_MUX_AE
#if BUFFER_SIZE_MUX_AE < 255
	 || (unsigned char)line[-1] > BUFFER_SIZE_MUX_AE
#endif
	 || line[BUFFER_SIZE_MUX_AE]) {
		/* Yiek! That looks very much like an overflow!! */
		dprintf( ("[Memory corrupted during Installable Commands handler]\n") );
		longjmp(jmp_beginning, E_CorruptMemory);
	}

	/* Check command and transform it back into C-style string */
	p = command + command[-1];
	while(--p >= command && isspace(*p));
	p[1] = 0;

	/* Check the command line and transform it into a C-style string */
	/* Must terminate as line[BUFFER_SIZE] == 0 */
	for(p = line; *p && *p != '\xd'; ++p);
	*p = 0;

	return 0;			/* Proceed command processing as usual */
}
