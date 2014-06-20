#CC=		gcc
CC=		cc
CFLAGS=		-O
MAN=		/usr/man/man3

OBJ=		dld.o dld_find_executable.o

all:		libdld.a

libdld.a:	$(OBJ)
		rm -f $@
		ar ru $@ $(OBJ)
		ranlib $@
		
libdld_p.a:	$(OBJ)
		rm -f $@
		ar ru $@ $(OBJ)
		ranlib $@
		
install:	all
		install -c libdld.a /usr/lib
		ranlib /usr/lib/libdld.a
		install -c dld.h /usr/include
		install -c doc/dld.3 $(MAN)
		install -c doc/dld_find_executable.3 $(MAN)

clean:
		rm $(OBJ) libdld.a
