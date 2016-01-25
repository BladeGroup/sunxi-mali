include Makefile.setup
include config.mk

.PHONY : test

pkgconfigs = egl.pc gles_cm.pc glesv2.pc

all: config.mk $(pkgconfigs)
	$(MAKE) -C include
	$(MAKE) -C lib

config:
	rm -f config.mk
	$(MAKE) config.mk

config.mk:
	$(MAKE) -f Makefile.config

clean:
	$(MAKE) -C version clean
	$(MAKE) -C test clean
	$(MAKE) -C lib clean
	$(MAKE) -C include clean
	rm -f config.mk $(pkgconfigs)

install: all config.mk
	$(MAKE) -C lib install
	$(MAKE) -C include install
	$(MKDIR) $(libdir)/pkgconfig
	$(INSTALL_DATA) $(pkgconfigs) $(libdir)/pkgconfig

test: config.mk
	$(MAKE) -C test test

%.pc: %.pc.in
	echo "prefix=$(prefix)" > $@
	sed "s/MVERSION/${MALI_VERSION}/g" $^ >> $@
