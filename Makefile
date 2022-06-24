MANIFEST ?= manifest.xml
RESOURCES ?= $(wildcard resources/**/*)
SOURCES ?= $(wildcard src/*.mc)
KEY ?= signing-key.der

DEVICE ?= fenix6xpro

.PHONY: build
build: build/bitware$(DEVICE).prg

start: build/bitware$(DEVICE).prg
	ps -C simulator || simulator & \
	monkeydo build/bitware$(DEVICE).prg $(DEVICE)

GIT_VERSION=$(shell git describe HEAD --always)
release: build/bitware-$(GIT_VERSION).iq

%.prg: $(KEY) $(MANIFEST) $(RESOURCES) $(SOURCES)
	monkeyc -o $@ -w -y $(KEY) -f $(PWD)/monkey.jungle -d $(DEVICE)

%_release.prg: $(KEY) $(MANIFEST) $(RESOURCES) $(SOURCES)
	monkeyc -o $@ -w -r -y $(KEY) -f $(PWD)/monkey.jungle -d $(DEVICE)

%.iq: $(KEY) $(MANIFEST) $(RESOURCES) $(SOURCES)
	monkeyc -o $@ -e -w -r -y $(KEY) -f $(PWD)/monkey.jungle

clean:
	rm -rf build/