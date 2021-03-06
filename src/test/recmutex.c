/*  $Id: recmutex.c,v 1.1 2000/01/29 17:00:56 jan Exp $

    Part of SWI-Prolog
    Designed and implemented by Frank Cornelissen
    Copyright: GPL-2
*/

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <string.h>
#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

pthread_mutex_t *my_mutex;

int locked = 1;

void *
test_recursive(void *arg)
{ int status = pthread_mutex_lock(my_mutex);

  if ( status != 0 )
  { fprintf(stderr,"error while locking mutex (1):%s\n",
	    strerror(status));
    exit(1);
  }

  status = pthread_mutex_lock(my_mutex);
  if ( status != 0 )
  { fprintf(stderr,"error while locking mutex (2) \n");
    exit(1);
  }

  locked = 0;
  status = pthread_mutex_unlock(my_mutex);
  if ( status != 0 )
  { fprintf(stderr,"error while unlocking mutex (2) \n");
    exit(1);
  }

  status = pthread_mutex_unlock(my_mutex);
  if ( status != 0 )
  { fprintf(stderr,"error while unlocking mutex (1) \n");
    exit(1);
  }

  pthread_exit(NULL);
  return NULL;
}


int
main(int argc, char **argv)
{ int status;
  pthread_t thread_id;
  pthread_mutexattr_t attr;
	
  my_mutex = malloc(sizeof(pthread_mutex_t));
  pthread_mutexattr_init(&attr);
#ifdef HAVE_PTHREAD_MUTEXATTR_SETKIND_NP
  pthread_mutexattr_setkind_np(&attr, PTHREAD_MUTEX_RECURSIVE_NP);
#else
#ifdef HAVE_PTHREAD_MUTEXATTR_SETTYPE
  pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
#endif
#endif
  pthread_mutex_init(my_mutex,&attr);

  status = pthread_create(&thread_id,NULL,test_recursive,NULL);
  sleep(1);
  exit(locked);
}
