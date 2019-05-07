DESTDIR ?= /

all:
	@echo "Nothing to be done."	

install:
	mkdir -p $(DESTDIR)/etc/udev/rules.d/
	cp udev/88-moxa-module-control-probe.rules $(DESTDIR)/etc/udev/rules.d/

	mkdir -p $(DESTDIR)/lib/systemd/system/
	cp systemd_service/moxa-module-control.service $(DESTDIR)/lib/systemd/system/

	mkdir -p $(DESTDIR)/etc/moxa-module-control/
	cp systemd_service/moxa-module-control-srv $(DESTDIR)/etc/moxa-module-control/
	cp udev/moxa-module-control-probe $(DESTDIR)/etc/moxa-module-control/
	cp -r udev/modules.d/ $(DESTDIR)/etc/moxa-module-control/

	mkdir -p $(DESTDIR)/sbin/
	cp mx-module-ctl $(DESTDIR)/sbin/
