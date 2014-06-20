/*  $Id: pl-sys.c,v 1.24 2000/02/17 11:56:23 jan Exp $

    Part of SWI-Prolog

    Author:  Jan Wielemaker
    E-mail:  jan@swi.psy.uva.nl
    WWW:     http://www.swi.psy.uva.nl/projects/SWI-Prolog/
    Copying: GPL-2.  See the file COPYING or http://www.gnu.org

    Copyright (C) 1990-2000 SWI, University of Amsterdam. All rights reserved.
*/

#include "pl-incl.h"

#ifdef HAVE_FTIME
#include <sys/timeb.h>
#endif

#ifndef MAXVARNAME
#define MAXVARNAME 1024
#endif

word
pl_shell(term_t command, term_t status)
{ char *cmd;

  if ( PL_get_chars(command, &cmd, CVT_ALL) )
  { int rval = System(cmd);

    return PL_unify_integer(status, rval);
  }
  
  return warning("shell/1: instantiation fault");
}


word
pl_getenv(term_t var, term_t value)
{ char *n;

  if ( PL_get_chars(var, &n, CVT_ALL) )
  { int len = getenvl(n);

    if ( len >= 0 )
    { char *buf	= alloca(len+1);
      
      if ( buf )
      { char *s;

	if ( (s=getenv3(n, buf, len+1)) )
	  return PL_unify_atom_chars(value, s);
      } else
	return PL_error("getenv", 2, NULL, ERR_NOMEM);
    }

    fail;
  }

  return warning("getenv/2: instantiation fault");
}  


word
pl_setenv(term_t var, term_t value)
{ char *n, *v;

  if ( PL_get_chars(var, &n, CVT_ALL|BUF_RING) &&
       PL_get_chars(value, &v, CVT_ALL) )
  { Setenv(n, v);
    succeed;
  }

  return warning("setenv/2: instantiation fault");
}


word
pl_unsetenv(term_t var)
{ char *n;

  if ( PL_get_chars(var, &n, CVT_ALL) )
  { Unsetenv(n);

    succeed;
  }

  return warning("unsetenv/1: instantiation fault");
}


word
pl_convert_time(term_t time, term_t year, term_t month,
		term_t day, term_t hour, term_t minute,
		term_t second, term_t usec)
{ double tf;

  if ( PL_get_float(time, &tf) && tf <= PLMAXINT && tf >= PLMININT )
  { long t    = (long) tf;
    long us   = (long)((tf - (double) t) * 1000.0);
    struct tm *tm = LocalTime(&t);

    if ( PL_unify_integer(year,   tm->tm_year + 1900) &&
	 PL_unify_integer(month,  tm->tm_mon + 1) &&
	 PL_unify_integer(day,    tm->tm_mday) &&
	 PL_unify_integer(hour,   tm->tm_hour) &&
	 PL_unify_integer(minute, tm->tm_min) &&
	 PL_unify_integer(second, tm->tm_sec) &&
	 PL_unify_integer(usec,   us) )
      succeed;
    else
      fail;
  }

  return PL_error("convert_time", 8, NULL, ERR_TYPE, ATOM_time_stamp, time);
}


word
pl_convert_time2(term_t time, term_t string)
{ double tf;

  if ( PL_get_float(time, &tf) && tf <= PLMAXINT && tf >= PLMININT )
  { time_t t  = (time_t)(long)tf;
    char *s = ctime(&t);

    if ( s )
    { char *e = s + strlen(s);
      while(e>s && e[-1] == '\n')
	e--;
      *e = EOS;

      return PL_unify_string_chars(string, s);
    }

    return warning("convert_time/2: %s", OsError());
  }
  
  return PL_error("convert_time", 2, NULL, ERR_TYPE, ATOM_time_stamp, time);
}


word
pl_get_time(term_t t)
{ double stime;
#ifdef HAVE_GETTIMEOFDAY
  struct timeval tp;

  gettimeofday(&tp, NULL);
  stime = (double)tp.tv_sec + (double)tp.tv_usec/1000000.0;
#else
#ifdef HAVE_FTIME
  struct timeb tb;

  ftime(&tb);
  stime = (double)tb.time + (double)tb.millitm/1000.0;
#else
  stime = (double)time((time_t *)NULL);
#endif
#endif

  return PL_unify_float(t, stime);
}


word
pl_sleep(term_t time)
{ double t;

  if ( PL_get_float(time, &t) )
    Pause(t);
  
  succeed;
}

#ifdef __WIN32__
#include <process.h>
#endif

word
pl_get_pid(term_t pid)
{ return PL_unify_integer(pid, getpid());
}
