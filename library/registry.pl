/*  $Id: registry.pl,v 1.5 2000/03/08 10:09:22 jan Exp $

    Part of SWI-Prolog
    Copyright (c) 1996 University of Amsterdam. All rights reserved.
    See ../LICENCE to find out about your rights.
    E-mail: jan@swi.psy.uva.nl

    Purpose: Provide access to the Win32 registry
*/

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
This module requires plregtry.ddl, for  which   the  sources  are in the
dlldemo directory.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- module(win_registry,
	  [ registry_get_key/2,		% +Path, -Value
	    registry_get_key/3,		% +Path, +Name, -Value
	    registry_set_key/2,	        % +Path, +Value
	    registry_set_key/3,		% +Path, +Name, +Value
	    registry_delete_key/1,	% +Path
	    registry_lookup_key/3,	% +Path, +Access, -Key
	    
	    shell_register_file_type/4,	% +Ext, +Type, +Name, +Open
	    shell_register_dde/6,	% +Type, +Action,
					% +Service, Topic, +DDECommand
					% +IfNotRunning
	    shell_register_prolog/1	% +Extension
	  ]).

:- load_foreign_library(swi('bin/plregtry')).	% load plregtry.ddl

		 /*******************************
		 *	 REGISTER PROLOG	*
		 *******************************/

shell_register_prolog(Ext) :-
	current_prolog_flag(argv, [Me|_]),
	concat_atom(['"', Me, '" "%1"'], OpenCommand),
	shell_register_file_type(Ext, 'prolog.type', 'Prolog Source',
				 OpenCommand),
	shell_register_dde('prolog.type', consult,
			   prolog, control, 'consult(''%1'')', Me), 
	shell_register_dde('prolog.type', edit,
			   prolog, control, 'edit(''%1'')', Me).


		 /*******************************
		 *     WINDOWS SHELL STUFF	*
		 *******************************/

%	shell_register_file_type(+Extension, +Type, +Name, +OpenCommand)
%
%	Register an extension to a type.  The open command for the type
%	is defined and files with this extension will be given Name as
%	their description in the explorer.  For example:
% 
%	?- shell_register_file_type(pl, 'prolog.type', 'Prolog Source',
%				    '"c:\pl\bin\plwin.exe" "%1"').

shell_register_file_type(Ext, Type, Name, Open) :-
	ensure_dot(Ext, DExt),
	registry_set_key(classes_root/DExt, Type),
	registry_set_key(classes_root/Type, Name),
	registry_set_key(classes_root/Type/shell/open/command, Open).

ensure_dot(Ext, Ext) :-
	atom_concat('.', _, Ext), !.
ensure_dot(Ext, DExt) :-
	atom_concat('.', Ext, DExt).

%	Register a DDE command for the type.  The example below will
%	send DDE_EXECUTE command `consult('<File>') to the service
%	prolog, given the topic control.
%
%	shell_register_dde('prolog.type', consult,
%			   prolog, control, 'consult(''%1'')',
%			   'c:\pl\bin\plwin.exe -g "edit(''%1'')"').

shell_register_dde(Type, Action, Service, Topic, DDECommand, IfNotRunning) :-
	registry_make_key(classes_root/Type/shell/Action/ddeexec,
			  all_access, EKey),
	registry_set_key(classes_root/Type/shell/Action/command, IfNotRunning),
	reg_set_value(EKey, '', DDECommand),
	registry_set_key(EKey/'Application', Service),
	registry_set_key(EKey/ifexec, ''),
	registry_set_key(EKey/topic, Topic),
	reg_close_key(EKey).

		 /*******************************
		 *	  REGISTRY STUFF	*
		 *******************************/

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
In the commands below, Path refers to   the path-name of the registry. A
path is a '/' separated description, where   the / should be interpreted
as a Prolog operator. For example, classes_root/'prolog.type'/shell. The
components should be atoms.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

%	registry_set_key(+Path, [+Name], +Value)
%
%	Associate a (string) value with the key described by Path.  If
%	part of the path does not exist, the required keys will be created.

registry_set_key(Path, Value) :-
	registry_set_key(Path, '', Value).
registry_set_key(Path, Name, Value) :-
	registry_make_key(Path, write, Key, Close),
	reg_set_value(Key, Name, Value),
	Close.
	
%	registry_get_key(+Path, [+Name], -Value)
%
%	Get the value associated with the given key.  If the key does not
%	exists, the predicate fails silently.

registry_get_key(Path, Value) :-
	registry_get_key(Path, '', Value).
registry_get_key(Path, Name, Value) :-
	registry_lookup_key(Path, read, Key, Close),
	(   reg_get_value(Key, Name, RawVal)
	->  Close,
	    Value = RawVal
	;   Close,
	    fail
	).
	
%	registry_delete_key(+Path)
%
%	Delete the gven key and all its subkeys and values.  Note that
%	the root-keys cannot be deleted.

registry_delete_key(Parent/Node) :- !,
	registry_lookup_key(Parent, all_access, PKey),
	(   reg_open_key(PKey, Node, all_access, Key)
	->  delete_subkeys(Key),
	    reg_close_key(Key),
	    reg_delete_key(PKey, Node)
	),
	reg_close_key(PKey).

delete_subkeys(Parent) :-
	reg_subkeys(Parent, Subs),
	forall(member(Sub, Subs),
	       delete_subkey(Parent, Sub)).

delete_subkey(Parent, Sub) :-
	reg_open_key(Parent, Sub, all_access, Key),
	delete_subkeys(Key),
	reg_close_key(Key),
	reg_delete_key(Parent, Sub).

%	registry_make_key(+Path, +Access, -Key)
%
%	Open the given key and create required keys if the path does not
%	exist.

registry_make_key(Path, Access, Key) :-
	registry_make_key(Path, Access, Key, _).

registry_make_key(A/B, Access, Key, Close) :- !,
	registry_make_key(A, Access, Parent, CloseParent),
	(   reg_open_key(Parent, B, Access, RawKey)
	->  true
	;   reg_create_key(Parent, B, '', [], Access, RawKey)
	),
	CloseParent,
	Close = reg_close_key(RawKey),
	Key = RawKey.
registry_make_key(Key, _, Key, true).

%	registry_lookup_key(+Path, +Access, -Key)
%	
%	Open the given key, fail silently if the key doesn't
%	exist.

registry_lookup_key(Path, Access, Key) :-
	registry_lookup_key(Path, Access, Key, _).

registry_lookup_key(A/B, Access, Key, Close) :- !,
	registry_lookup_key(A, Access, Parent, CloseParent),
	reg_open_key(Parent, B, Access, RawKey),
	CloseParent,
	Close = reg_close_key(RawKey),
	Key = RawKey.
registry_lookup_key(Key, _, Key, true).

