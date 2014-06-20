/*  $Id: list.pl,v 1.6 1999/05/05 13:47:15 jan Exp $

    Copyright (c) 1990 Jan Wielemaker. All rights reserved.
    jan@swi.psy.uva.nl

    Purpose: basic list predicates
*/

:- module($list,
	[ length/2
	, delete/3
	, nth0/3
	, nth1/3
	, last/2
	, reverse/2
	, flatten/2
	, is_set/1
	, list_to_set/2
	, intersection/3
	, union/3
	, subset/2
	, subtract/3
	]).

%	length(?List, ?N)
%	Is true when N is the length of List.

length(List, Length) :-
	$length(List, Length), !.		% written in C
length(List, Length) :-
	var(Length),
	length2(List, Length).

length2([], 0).
length2([_|List], N) :-
	length2(List, M), 
	succ(M, N).

%	delete(?List1, ?Elem, ?List2)
%	Is true when Lis1, with all occurences of Elem deleted results in
%	List2.

delete([], _, []) :- !.
delete([Elem|Tail], Elem, Result) :- !, 
	delete(Tail, Elem, Result).
delete([Head|Tail], Elem, [Head|Rest]) :-
	delete(Tail, Elem, Rest).

/*  nth0/3, nth1/3 are improved versions from
    Martin Jansche <martin@pc03.idf.uni-heidelberg.de>
*/

%%  nth0(?Index, ?List, ?Elem)
%%  is true when Elem is the Index'th element of List.  Counting starts
%%  at 0.  [This is a faster version of the original SWI-Prolog predicate.]

nth0(Index, List, Elem) :-
        integer(Index), !,
        Index >= 0,
        nth0_det(Index, List, Elem).    %% take nth deterministically
nth0(Index, List, Elem) :-
        var(Index), !,
        nth_gen(List, Elem, 0, Index).  %% match

nth0_det(0, [Elem|_], Elem) :- !.
nth0_det(1, [_,Elem|_], Elem) :- !.
nth0_det(2, [_,_,Elem|_], Elem) :- !.
nth0_det(3, [_,_,_,Elem|_], Elem) :- !.
nth0_det(4, [_,_,_,_,Elem|_], Elem) :- !.
nth0_det(5, [_,_,_,_,_,Elem|_], Elem) :- !.
nth0_det(N, [_,_,_,_,_,_   |Tail], Elem) :-
        M is N - 6,
        nth0_det(M, Tail, Elem).

nth_gen([Elem|_], Elem, Base, Base).
nth_gen([_|Tail], Elem, N, Base) :-
        succ(N, M),
        nth_gen(Tail, Elem, M, Base).


%%  nth1(?Index, ?List, ?Elem)
%%  Is true when Elem is the Index'th element of List.  Counting starts
%%  at 1.  [This is a faster version of the original SWI-Prolog predicate.]

nth1(Index1, List, Elem) :-
        integer(Index1), !,
        Index0 is Index1 - 1,
        nth0_det(Index0, List, Elem).   %% take nth deterministically
nth1(Index, List, Elem) :-
        var(Index), !,
        nth_gen(List, Elem, 1, Index).  %% match

%	last(?Elem, ?List)
%	Succeeds if `Last' unifies with the last element of `List'.
%	Modified after discussion on the comp.lang.prolog.  This version
%	is a little faster and deterministic as well as logical.

last(Elem, [H|T]) :-
	last(T, H, Elem).

last([], X, X).
last([H|T], _, X) :-
	last(T, H, X).

%	reverse(?List1, ?List2)
%	Is true when the elements of List2 are in reverse order compared to
%	List1.

reverse(L1, L2) :-
	$reverse(L1, [], L2).

$reverse([], List, List).
$reverse([Head|List1], List2, List3) :-
	$reverse(List1, [Head|List2], List3).

%	flatten(+List1, ?List2)
%	Is true when Lis2 is a non nested version of List1.

flatten(List, FlatList) :-
	$flatten(List, [], FlatList0), !,
	FlatList = FlatList0.

$flatten(Var, Tl, [Var|Tl]) :-
	var(Var), !.
$flatten([], Tl, Tl) :- !.
$flatten([Hd|Tl], Tail, List) :-
	$flatten(Hd, FlatHeadTail, List), 
	$flatten(Tl, Tail, FlatHeadTail).
$flatten(Atom, Tl, [Atom|Tl]).


		/********************************
		*       SET MANIPULATION        *
		*********************************/

%	is_set(+Set)
%	is True if Set is a proper list without duplicates.

is_set(0) :- !, fail.		% catch variables
is_set([]) :- !.
is_set([H|T]) :-
	memberchk(H, T), !, 
	fail.
is_set([_|T]) :-
	is_set(T).

%	list_to_set(+List, ?Set)
%	is true when Set has the same element as List in the same order

list_to_set(List, Set) :-
	list_to_set_(List, Set0),
	Set = Set0.

list_to_set_([], R) :-
	close_list(R).
list_to_set_([H|T], R) :-
	memberchk(H, R), !, 
	list_to_set_(T, R).

close_list([]) :- !.
close_list([_|T]) :-
	close_list(T).

%	intersection(+Set1, +Set2, -Set3)
%	Succeeds if Set3 unifies with the intersection of Set1 and Set2

intersection([], _, []) :- !.
intersection([X|T], L, Intersect) :-
	memberchk(X, L), !, 
	Intersect = [X|R], 
	intersection(T, L, R).
intersection([_|T], L, R) :-
	intersection(T, L, R).

%	union(+Set1, +Set2, -Set3)
%	Succeeds if Set3 unifies with the union of Set1 and Set2

union([], L, L) :- !.
union([H|T], L, R) :-
	memberchk(H, L), !, 
	union(T, L, R).
union([H|T], L, [H|R]) :-
	union(T, L, R).

%	subset(+SubSet, +Set)
%	Succeeds if all elements of SubSet belong to Set as well.

subset([], _) :- !.
subset([E|R], Set) :-
	memberchk(E, Set), 
	subset(R, Set).

%	subtract(+Set, +Delete, -Result)
%	Delete all elements from `Set' that occur in `Delete' (a set) and
%	unify the result with `Result'.

subtract([], _, []) :- !.
subtract([E|T], D, R) :-
	memberchk(E, D), !,
	subtract(T, D, R).
subtract([H|T], D, [H|R]) :-
	subtract(T, D, R).
