/*  $Id: pl-table.c,v 1.22 2000/02/17 11:56:23 jan Exp $

    Part of SWI-Prolog

    Author:  Jan Wielemaker
    E-mail:  jan@swi.psy.uva.nl
    WWW:     http://www.swi.psy.uva.nl/projects/SWI-Prolog/
    Copying: GPL-2.  See the file COPYING or http://www.gnu.org

    Copyright (C) 1990-2000 SWI, University of Amsterdam. All rights reserved.
*/

/*#define O_DEBUG 1*/
#include "pl-incl.h"
#define LOCK()   PL_LOCK(L_TABLE)
#define UNLOCK() PL_UNLOCK(L_TABLE)

static inline Symbol rawAdvanceTableEnum(TableEnum e);

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
This file provides generic hash-tables. Most   of  the implementation is
rather  straightforward.  Special  are  the  *TableEnum()  functions  to
create, advance over and destroy enumerator   objects. These objects are
used to enumerate the symbols of these   tables,  used primarily for the
pl_current_* predicates.

The  enumerators  cause  two  things:  (1)    as  long  enumerators  are
associated, the table will not  be  rehashed   and  (2)  if  symbols are
deleted  that  are  referenced  by  an  enumerator,  the  enumerator  is
automatically advanced to the next free symbol.  This, in general, makes
the enumeration of hash-tables safe.

TODO: abort should delete  any  pending   enumerators.  This  should  be
thread-local, as thread_exit/1 should do the same.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

static void
allocHTableEntries(Table ht)
{ int n;
  Symbol *p;

  ht->entries = allocHeap(ht->buckets * sizeof(Symbol));

  for(n=0, p = &ht->entries[0]; n < ht->buckets; n++, p++)
    *p = NULL;
}


Table
newHTable(int buckets)
{ Table ht;

  ht		  = allocHeap(sizeof(struct table));
  ht->buckets	  = buckets;
  ht->size	  = 0;
  ht->enumerators = NULL;
  ht->free_symbol = NULL;
  ht->copy_symbol = NULL;

  allocHTableEntries(ht);
  return ht;
}


void
destroyHTable(Table ht)
{ clearHTable(ht);
  freeHeap(ht->entries, ht->buckets * sizeof(Symbol));
  freeHeap(ht, sizeof(struct table));
}


#if O_DEBUG || O_HASHSTAT
#define HASHSTAT(c) c
static int lookups;
static int cmps;

void
exitTables(int status, void *arg)
{ Sdprintf("hashstat: Anonymous tables: %d lookups using %d compares\n",
	   lookups, cmps);
}
#else
#define HASHSTAT(c)
#endif /*O_DEBUG*/


void
initTables()
{ static int done = FALSE;

  LOCK();
  if ( !done )
  { done = TRUE;
    
    initMemAlloc();
    HASHSTAT(PL_on_halt(exitTables, NULL));
  }
  UNLOCK();
}


Symbol
lookupHTable(Table ht, void *name)
{ Symbol s = ht->entries[pointerHashValue(name, ht->buckets)];

  HASHSTAT(lookups++);
  for( ; s; s = s->next)
  { HASHSTAT(cmps++);
    if ( s->name == name )
      return s;
  }

  return NULL;
}

#ifdef O_DEBUG
void
checkHTable(Table ht)
{ int i;
  int n = 0;

  for(i=0; i<ht->buckets; i++)
  { Symbol s;

    for(s=ht->entries[i]; s; s=s->next)
    { assert(lookupHTable(ht, s->name) == s);
      n++;
    }
  }

  assert(n == ht->size);
}
#endif

/* MT: Locked by calling addHTable()
*/

static void
rehashHTable(Table ht)
{ Symbol *oldtab;
  int    oldbucks;
  int    i;

  oldtab   = ht->entries;
  oldbucks = ht->buckets;
  ht->buckets *= 2;
  allocHTableEntries(ht);

  DEBUG(1, Sdprintf("Rehashing table %p to %d entries\n", ht, ht->buckets));

  for(i=0; i<oldbucks; i++)
  { Symbol s, n;

    for(s=oldtab[i]; s; s = n)
    { int v = pointerHashValue(s->name, ht->buckets);

      n = s->next;
      s->next = ht->entries[v];
      ht->entries[v] = s;
    }
  }

  freeHeap(oldtab, oldbucks * sizeof(Symbol));
  DEBUG(0, checkHTable(ht));
}


bool
addHTable(Table ht, void *name, void *value)
{ Symbol s;
  int v;

  LOCK();
  v = pointerHashValue(name, ht->buckets);
  if ( lookupHTable(ht, name) )
  { UNLOCK();
    fail;
  }
  s = allocHeap(sizeof(struct symbol));
  s->name  = name;
  s->value = value;
  s->next  = ht->entries[v];
  ht->entries[v] = s;
  ht->size++;
  DEBUG(9, Sdprintf("addHTable(0x%x, 0x%x, 0x%x) --> size = %d\n",
		    ht, name, value, ht->size));

  if ( ht->buckets * 2 < ht->size && !ht->enumerators )
    rehashHTable(ht);
  UNLOCK();

  DEBUG(1, checkHTable(ht));
  succeed;
}  


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Note: s must be in the table!
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

void
deleteSymbolHTable(Table ht, Symbol s)
{ int v;
  Symbol *h;
  TableEnum e;

  LOCK();
  v = pointerHashValue(s->name, ht->buckets);
  h = &ht->entries[v];

  for( e=ht->enumerators; e; e = e->next )
  { if ( e->current == s )
      rawAdvanceTableEnum(e);
  }

  for( ; *h; h = &(*h)->next )
  { if ( *h == s )
    { *h = (*h)->next;

      freeHeap(s, sizeof(struct symbol));
      ht->size--;

      break;
    }
  }

  UNLOCK();
}


void
clearHTable(Table ht)
{ int n;
  TableEnum e;

  LOCK();
  for( e=ht->enumerators; e; e = e->next )
  { e->current = NULL;
    e->key     = ht->buckets;
  }

  for(n=0; n < ht->buckets; n++)
  { Symbol s, q;

    for(s = ht->entries[n]; s; s = q)
    { q = s->next;

      if ( ht->free_symbol )
	(*ht->free_symbol)(s);

      freeHeap(s, sizeof(struct symbol));
    }

    ht->entries[n] = NULL;
  }

  ht->size = 0;
  UNLOCK();
}


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Table copyHTable(Table org)
    Make a copy of a hash-table.  This is used to realise the copy-on-write
    as defined by SharedTable.  The table is copied to have exactly the
    same dimensions as the original.  If the copy_symbol function is
    provided, it is called to allow duplicating the symbols name or value
    fields.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

Table
copyHTable(Table org)
{ Table ht;
  int n;

  LOCK();
  ht = allocHeap(sizeof(struct table));
  *ht = *org;				/* copy all attributes */
  allocHTableEntries(ht);

  for(n=0; n < ht->buckets; n++)
  { Symbol s, *q;

    q = &ht->entries[n];
    for(s = org->entries[n]; s; s = s->next)
    { Symbol s2 = allocHeap(sizeof(*s2));

      *q = s2;
      q = &s2->next;
      s2->name = s->name;
      s2->value = s->value;

      if ( ht->copy_symbol )
	(*ht->copy_symbol)(s2);
    }
    *q = NULL;
  }
  UNLOCK();

  return ht;
}


		 /*******************************
		 *	    ENUMERATING		*
		 *******************************/

TableEnum
newTableEnum(Table ht)
{ TableEnum e = allocHeap(sizeof(struct table_enum));
  Symbol n;

  LOCK();
  e->table	  = ht;
  e->key	  = 0;
  e->next	  = ht->enumerators;
  ht->enumerators = e;

  n = ht->entries[0];
  while(!n && ++e->key < ht->buckets)
    n=ht->entries[e->key];
  e->current = n;
  UNLOCK();

  return e;
}


void
freeTableEnum(TableEnum e)
{ TableEnum *ep;
  Table ht;

  if ( !e )
    return;

  LOCK();

  ht = e->table;
  for( ep=&ht->enumerators; *ep ; ep = &(*ep)->next )
  { if ( *ep == e )
    { *ep = (*ep)->next;

      freeHeap(e, sizeof(*e));
      break;
    }
  }

  UNLOCK();
}


static inline Symbol
rawAdvanceTableEnum(TableEnum e)
{ Symbol s, n;
  Table ht = e->table;

  if ( !(s = e->current) )
    return s;
  n = s->next;

  while(!n)
  { if ( ++e->key >= ht->buckets )
    { e->current = NULL;
      return s;
    }

    n=ht->entries[e->key];
  }
  e->current = n;

  return s;
}


Symbol
advanceTableEnum(TableEnum e)
{ Symbol s;

  LOCK();
  s = rawAdvanceTableEnum(e);
  UNLOCK();

  return s;
}
