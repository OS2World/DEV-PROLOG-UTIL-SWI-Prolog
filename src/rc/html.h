/*  $Id: html.h,v 1.3 2000/02/17 11:56:24 jan Exp $

    Part of SWI-Prolog

    Author:  Jan Wielemaker
    E-mail:  jan@swi.psy.uva.nl
    WWW:     http://www.swi.psy.uva.nl/projects/SWI-Prolog/
    Copying: GPL-2.  See the file COPYING or http://www.gnu.org

    Copyright (C) 1990-2000 SWI, University of Amsterdam. All rights reserved.
*/

#ifndef HTML_H_INCLUDED
#define HTML_H_INCLUDED

#ifndef TRUE
#define TRUE 1
#define FALSE 0
#endif

#define HTML_TAG_STRING	0
#define HTML_TAG_SHORT	1
#define HTML_TAG_INT	2
#define HTML_TAG_LONG	3
#define HTML_TAG_FLOAT	4
#define HTML_TAG_DOUBLE	5
#define HTML_TAG_BOOL	6
#define HTML_TAG_ENUM   7

#define MAXTAGLEN 128
#define MAXTAGPROPLEN 1024

typedef int (*HtmlTagConverter)(const char *data, int len, void *dst,
				void *closure);

typedef struct
{ char		       *tag;		/* tag-name */
  int	 		offset;		/* byte-offset */
  HtmlTagConverter	convert;	/* conversion function */
  void		       *closure;	/* conversion closure */
} htmltagdef, *HtmlTagDef;

extern int html_fd_next_tag(FILE *fd, char *tag, char *props);
extern int html_fd_find_close_tag(FILE *fd, const char *etag);

extern char *html_decode_tag(const char *data, HtmlTagDef spec, void *dest);
extern char *html_find_tag(const char *data, const char *end, const char *tag);
extern char *html_find_close_tag(const char *data, const char *tag);

extern int html_cvt_malloc_string(const char *d, int len, void *dst, void *cl);
extern int html_cvt_long(const char *d, int len, void *dst, void *cl);
extern int html_cvt_date(const char *d, int len, void *dst, void *cl);

#endif /*HTML_TAG_ENUM*/
