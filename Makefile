#!/usr/bin/make -f

# This make file takes care of installing files

all: # nothing to build

# default install target is debian because that's the easist way to
#   set up the 'rules' file.
install: install-debian

install-common:
	mkdir -p $(DESTDIR)/etc/cvmfs/default.d \
	  $(DESTDIR)/etc/cvmfs/config.d \
	  $(DESTDIR)/etc/cvmfs/keys/opensciencegrid.org
	install -D -m 444 60-osg.conf $(DESTDIR)/etc/cvmfs/default.d
	install -D -m 444 config-osg.opensciencegrid.org.conf $(DESTDIR)/etc/cvmfs/config.d
	install -D -m 444 opensciencegrid.org.pub $(DESTDIR)/etc/cvmfs/keys/opensciencegrid.org

install-debian: install-common
	mkdir -p $(DESTDIR)/etc/auto.master.d
	install -D -m 0644 cvmfs.autofs $(DESTDIR)/etc/auto.master.d

# assume DESTDIR=$RPM_BUILD_ROOT is passed in
install-redhat: install-common
