################################################################
# Simple relaying Makefile.  For details, please see src/Makefile.in
#
# See also ./configure
################################################################

BUILDARCH=src

all:
	@cd $(BUILDARCH) && $(MAKE) $@

install:
	@cd $(BUILDARCH) && $(MAKE) $@

rpm-install:
	@cd $(BUILDARCH) && $(MAKE) $@

clean:
	@cd $(BUILDARCH) && $(MAKE) $@

distclean:
	@cd $(BUILDARCH) && $(MAKE) $@
