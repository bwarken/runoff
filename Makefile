# Makefile.in for `RUNOFF'

# Copyright (C) 2014 Bernd Warken <bernd.warken@web.de>

# Last update: 5 Jan 2014

# This file is part of `RUNOFF'.

# This file is part of RUNOFF, a free software project.

# You can redistribute it and/or modify it under the terms of the GNU
# General Public License version 2 or (at your option) any later
# version. as published by the Free Software Foundation (FSF).

# You can find the text of this license in the file `gpl-2.0.txt'
# in this package.  It is also available in the internet at
# <http://www.gnu.org/licenses/gpl-2.0.html>.

########################################################################

RM=rm -f
CP=cp -a
MKDIR=mkdir -p

MAN1=runoff2mom.1

MAN7=\
	runoff.7 \
	runoff_filenames.7 \
	runoff_history.7

PREFIX=/usr/local
MANDIR=$(PREFIX)/share/man
MAN1DIR=$(MANDIR)/man1
MAN7DIR=$(MANDIR)/man7

PROG=runoff2mom
BINDIR=/usr/local/bin

DIRS=$(MAN1DIR) $(MAN7DIR) $(BINDIR)

all: $(PROG)

$(PROG): $(PROG).pl
	$(CP) $< $@

$(BINDIR):
	test -d $(BINDIR) || $(MKDIR) $(BINDIR)

$(MAN1DIR):
	test -d $(MAN1DIR) || $(MKDIR) $(MAN1DIR)

$(MAN7DIR):
	test -d $(MAN7DIR) || $(MKDIR) $(MAN7DIR)

install: $(MAN1) $(MAN7) $(PROG) $(DIRS)
	$(CP) $(PROG) $(BINDIR)
	$(CP) $(MAN1) $(MAN1DIR)
	$(CP) $(MAN7) $(MAN7DIR)

uninstall:
	$(RM) $(BINDIR)/$(PROG)
	for m in $(MAN1); do \
		$(RM) $(MAN1DIR)/$$m; \
	done
	for m in $(MAN7); do \
		$(RM) $(MAN7DIR)/$$m; \
	done

clean:
	$(RM) $(PROG)

########################################################################
# Emacs settings
########################################################################
#
# Local Variables:
# mode: makefile
# End:
