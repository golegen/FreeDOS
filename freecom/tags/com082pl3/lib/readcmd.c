/*	$Id: readcmd.c 740 2003-12-09 21:29:24Z skaus $
	$Locker$	$Name$	$State$

	Read a line from stdin

*/


#include "../config.h"

#include "../include/command.h"


void readcommand(char * const str, int maxlen)
{
#ifdef FEATURE_ENHANCED_INPUT
	/* If redirected from file or so, should use normal one */
	readcommandEnhanced(str, maxlen);
#else
	readcommandDOS(str, maxlen);
#endif
}

