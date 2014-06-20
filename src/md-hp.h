/*  md-hp.h,v 1.7 1993/02/23 13:16:22 jan Exp

    Copyright (c) 1990 Jan Wielemaker. All rights reserved.
    See ../LICENCE to find out about your rights.
    jan@swi.psy.uva.nl

    Purpose: Machine description for HP9000, HPUX 8.0
*/

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
This md- file  is for the  HP9000 series running  HP-UX.  The  initial
HP-port was  made by Jan Wielemaker  for the HP9000s300  running HP-UX
6.5.

Version  1.6 has been ported to  a HP9000s300 running  HP-UX 8.0 by T.
Kielman, June 1992 (kielmann@iti.informatik.th-darmstadt.de)

The current definition of this file is again from  Jan Wielemaker.  It
was  made on a HP9000s700 machine   running HP-UX, December 1992.  The
integrated version of SWI-Prolog is 1.6.7.  This port included:
	
	* Fixing various type-clashes
	* Support for process-data-area starting at 0x40000000L
	  (O_DATA_AT_0X4)
	* Debugged support for upwards growing C-stack in pl-save.c
	* Various small modifications in pl-save.c to reduce system
	  dependencies.  Probably benificial for other systems too.

It is unclear whether  or  not the  current   version compiles on  the
HP9000s300 series.

I would like to  thank Olle Ollson  at SICS (Sweden) for providing  me
with access to their HP machines.

Version 1.6.11 includes   various fixes suggested  by Dave   Sherratt,
(ads@compsci.liverpool.ac.uk)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

#ifndef __GNUC__
#define __GNUC__		0	/* set to 1 to use gcc */
#endif

#if __GNUC__				/* Use GNU-C */
#define M_CC			gcc
#define M_OPTIMIZE	        -O2
#define M_LDFLAGS		-static
#define M_CFLAGS		
#else					/* Use HP-UX cc */
#define M_CC			cc
#define M_OPTIMIZE	        +O3
#define M_LDFLAGS		-O -Wl,-a archive
#define M_CFLAGS		-Aa -D_HPUX_SOURCE -Dunix -Dhpux
#endif

#define M_LIBS			-lm -ltermcap

/*#define M_OPTIMIZE	        -g -DO_DEBUG*/

#define O_NO_ALLOCA		!__GNUC__
#define ANSI			__GNUC__
#define O_NO_LEFT_CAST		!__GNUC__
#define O_NO_VOID_POINTER	0
#define O_SHORT_SYMBOLS		0
			/* Operating system */
#define O_PROFILE		1
#define O_SIG_AUTO_RESET	1
#define O_SHARED_MEMORY		0
#define O_CAN_MAP		0
#define O_NO_SEGV_ADDRESS	0
#define MAX_VIRTUAL_ADDRESS	(220 * 1024 *1024)
#ifdef __hp9000s300
#define O_FOREIGN		1	/* I hope ... */
#else
#define O_DATA_AT_0X4		1
#define FIRST_DATA_SYMBOL	__data_start
#define O_C_STACK_GROWS_UP	1
#define STACK_BASE_ALIGN	1	/* i.e. do not align */
#define O_FOREIGN		0
#endif
#define O_SAVE			1
#define DEFAULT_PATH		":/usr/ucb:/bin:/usr/bin:/usr/local:.:";
			/* terminal driver */
#define O_TERMIOS 		1
#define O_EXTEND_ATOMS 		1
#define O_LINE_EDIT 		1
#define O_MAP_TAB_ON_ESC	1
#define O_FOLD 			0
			/* Interfaces */
#define O_PCE 			0

#define MACHINE			"hp"
#define OPERATING_SYSTEM	"hpux"
