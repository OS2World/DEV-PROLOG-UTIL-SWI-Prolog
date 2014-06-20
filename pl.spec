Summary:	SWI-Prolog - Edinburgh compatible Prolog compiler
Name:		pl
Version: 	4.0.9
Release:	42
Copyright:	GPL-2
Source:		ftp://swi.psy.uva.nl/pub/SWI-Prolog/pl-%{version}.tar.gz
Vendor:		Jan Wielemaker <jan@swi.psy.uva.nl>
Url:		http://www.swi.psy.uva.nl/projects/SWI-Prolog/
Packager:	Tony Nugent <Tony.Nugent@usq.edu.au>
Group:		Development/Languages
Prefix:		/usr
BuildRoot:	/var/tmp/pl
Provides:	pl-%{version}

%description
ISO/Edinburgh-style Prolog compiler including modules, autoload, libraries,
Garbage-collector, stack-expandor, C/C++-interface, GNU-readline interface,
very fast compiler.  Including packages clib (Unix process control and
sockets), cpp (C++ interface), sgml (reading XML/SGML), sgml/RDF (reading
RDF into triples) and XPCE (Graphics UI toolkit, integrated editor
(Emacs-clone) and graphical debugger).

If you only want the plain compiler, there is also SWI-Prolog/lite.
%prep
%setup

%build
env CFLAGS="$RPM_OPT_FLAGS" ./configure --prefix=/usr
(cd packages && env CFLAGS="$RPM_OPT_FLAGS" ./configure)
make
(cd packages && make)

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr
make install \
	prefix=$RPM_BUILD_ROOT/usr \
	bindir=$RPM_BUILD_ROOT/usr/bin \
	man_prefix=$RPM_BUILD_ROOT/usr/man
( cd packages && \
  make rpm-install \
	PLBASE=$RPM_BUILD_ROOT/usr/lib/pl-%{version} \
	prefix=$RPM_BUILD_ROOT/usr \
        bindir=$RPM_BUILD_ROOT/usr/bin \
	man_prefix=$RPM_BUILD_ROOT/usr/man \
)

# why are manpages installed twice?
rm -rf $RPM_BUILD_ROOT/usr/lib/pl-%{version}/man

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc ChangeLog README COPYING
%doc dotfiles/dot*
/usr/lib/pl-%{version}
/usr/man/man1/*
/usr/bin/pl*
/usr/bin/xpce
