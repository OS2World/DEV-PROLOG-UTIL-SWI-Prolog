/*  $Id: netscape.pl,v 1.2 2000/12/22 12:01:50 jan Exp $

    Designed and implemented by Jan Wielemaker
    E-mail: jan@swi.psy.uva.nl

    Copyright (C) 1998 University of Amsterdam. All rights reserved.
*/

:- module(netscape,
	  [ www_open_url/1
	  ]).

%	www_open_url(+Url)
%
%	Open URL in running version of netscape or start a new netscape.
%	Based on a windows-only version by Bob Wielinga

www_open_url(URL) :-
	feature(windows, true), !,
	(   current_predicate(_, win_shell(_,_))
	->  win_shell(open, URL)	% SWI-Prolog 3.4.5
	;   open_dde_conversation('NSShell', 'WWW_openUrl', Handle),
	    sformat(Request, '"~w"', [URL]),
	    dde_execute(Handle, Request)
	).
www_open_url(URL) :-
	(   shell('netscape -remote "xfeDoCommand(openBrowser)"', 0)
	->  sformat(Cmd, 'netscape -remote "openURL(~w)" &', [URL]),
	    shell(Cmd)
	;   sformat(Cmd, 'netscape "~w" &', [URL]),
	    shell(Cmd)
	).



