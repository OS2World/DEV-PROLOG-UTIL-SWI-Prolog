/*  $Id: pl-thread.h,v 1.15 2000/02/25 09:15:58 jan Exp $

    Part of SWI-Prolog

    Author:  Jan Wielemaker
    E-mail:  jan@swi.psy.uva.nl
    WWW:     http://www.swi.psy.uva.nl/projects/SWI-Prolog/
    Copying: GPL-2.  See the file COPYING or http://www.gnu.org

    Copyright (C) 1990-2000 SWI, University of Amsterdam. All rights reserved.
*/

#ifndef PL_THREAD_H_DEFINED
#define PL_THREAD_H_DEFINED

#ifdef O_PLMT
#include <pthread.h>

#ifdef HAVE_SEMA_INIT
#include <synch.h>
#endif

#define MAX_THREADS 100			/* for now */

typedef struct _PL_thread_info_t
{ int		    pl_tid;		/* Prolog thread id */
  unsigned long	    local_size;		/* Stack sizes */
  unsigned long	    global_size;
  unsigned long	    trail_size;
  unsigned long	    argument_size;
  int		    open_count;		/* for PL_thread_detach_engine() */
  bool		    detached;		/* detached thread */
  int		    status;		/* PL_THREAD_* */
  pthread_t	    tid;		/* Thread identifier */
#ifdef __linux__
  pid_t		    pid;		/* for identifying */
#endif
  PL_local_data_t  *thread_data;	/* The thread-local data  */
  module_t	    module;		/* Module for starting goal */
  record_t	    goal;		/* Goal to start thread */
  record_t	    return_value;	/* Value (term) returned */
} PL_thread_info_t;


#define PL_THREAD_MAGIC 0x2737234f

#define PL_THREAD_RUNNING	1
#define PL_THREAD_EXITED	2
#define PL_THREAD_SUCCEEDED	3
#define PL_THREAD_FAILED	4
#define PL_THREAD_EXCEPTION	5
#define PL_THREAD_CANCELED	6

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
				Thread-local data

All  thread-local  data  is  combined  in    one  structure  defined  in
pl-global.h. If Prolog is compiled for single-threading this is a simple
global variable and the macro LD is defined   to  pick up the address of
this variable. In multithreaded context,  POSIX pthread_getspecific() is
used to get separate versions for each  thread. Functions uisng LD often
may wish to write:

<header>
{ GET_LD
#undef LD
#define LD LOCAL_LD
  ...

#undef LD
#define LD GLOBAL_LD
}
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

extern pthread_key_t PL_ldata;		/* key to local data */
extern pthread_mutex_t _PL_mutexes[];	/* Prolog mutexes */

#define L_MISC		0
#define L_ALLOC		1
#define L_ATOM		2
#define L_FLAG	        3
#define L_FUNCTOR	4
#define L_RECORD	5
#define L_THREAD	6
#define L_PREDICATE	7
#define L_MODULE	8
#define L_TABLE		9
#define L_BREAK	       10
#define L_INIT_ALLOC   11
#define L_FILE	       12
#define L_FEATURE      13
#define L_OP	       14
#define L_INIT	       15

#ifdef O_DEBUG_MT
#define PL_LOCK(id) \
	do { Sdprintf("[%s] %s:%d: LOCK(%s)\n", \
		      threadName(0), \
		      __BASE_FILE__, __LINE__, #id); \
             pthread_mutex_lock(&_PL_mutexes[id]); \
	   } while(0)
#define PL_UNLOCK(id) \
	do { Sdprintf("[%s] %s:%d: UNLOCK(%s)\n", \
		      threadName(0), \
		      __BASE_FILE__, __LINE__, #id); \
	     pthread_mutex_unlock(&_PL_mutexes[id]); \
	   } while(0)
#else
#define PL_LOCK(id)   pthread_mutex_lock(&_PL_mutexes[id])
#define PL_UNLOCK(id) pthread_mutex_unlock(&_PL_mutexes[id])
#endif

#if 0
#define GET_LD    PL_local_data_t *__PL_ld = GLOBAL_LD;
#define GLOBAL_LD ((PL_local_data_t *)pthread_getspecific(PL_ldata))
#else
#define GET_LD	  PL_local_data_t *__PL_ld = GLOBAL_LD;
#define GLOBAL_LD _LD()
extern PL_local_data_t *_LD(void) __attribute((const));
#endif

#define ARG1_LD   PL_local_data_t *__PL_ld
#define ARG_LD    , ARG1_LD
#define PASS_LD1  LD
#define PASS_LD   , LD
#define LOCAL_LD  __PL_ld
#define LD	  GLOBAL_LD


extern PL_local_data_t *allocPrologLocalData(void);
extern void		initPrologThreads(void);
extern void		exitPrologThreads(void);
extern bool		aliasThread(int tid, atom_t name);
extern word		pl_thread_create(term_t goal, term_t id,
					 term_t options);
extern word		pl_thread_self(term_t self);
extern word		pl_thread_join(term_t thread, term_t retcode);
extern word		pl_thread_exit(term_t retcode);
extern word		pl_current_thread(term_t id, term_t status, word h);
extern word		pl_thread_kill(term_t thread, term_t sig);
extern word		pl_thread_send_message(term_t thread, term_t msg);
extern word		pl_thread_get_message(term_t msg);
extern word		pl_thread_peek_message(term_t msg);
extern foreign_t	pl_thread_signal(term_t thread, term_t goal);

extern foreign_t	pl_thread_at_exit(term_t goal);
extern int		PL_thread_self(void);

extern foreign_t	pl_mutex_create(term_t mutex);
extern foreign_t	pl_mutex_destroy(term_t mutex);
extern foreign_t	pl_mutex_lock(term_t mutex);
extern foreign_t	pl_mutex_trylock(term_t mutex);
extern foreign_t	pl_mutex_unlock(term_t mutex);
extern foreign_t	pl_mutex_unlock_all(void);
extern foreign_t	pl_current_mutex(term_t mutex,
					 term_t owner,
					 term_t count,
					 word h);

const char *		threadName(int id);
void			executeThreadSignals(int sig);
foreign_t		pl_attach_xterm(term_t in, term_t out);
void			threadMarkAtomsOtherThreads(void);

recursive_mutex_t *	newRecursiveMutex(void);
int			freeRecursiveMutex(recursive_mutex_t *m);
#else /*O_PLMT*/

		 /*******************************
		 *	 NON-THREAD STUFF	*
		 *******************************/

#define GET_LD
#define LOCAL_LD  (&PL_local_data)
#define GLOBAL_LD (&PL_local_data)
#define LD	  GLOBAL_LD

#define PL_LOCK(id)
#define PL_UNLOCK(id)

#endif /*O_PLMT*/

#endif /*PL_THREAD_H_DEFINED*/

