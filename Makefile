.PHONY: test clean install

PACKAGE = TAP.ipkg
IDRIS = idris

all: install

repl:
	$(IDRIS) TAP.idr

install: build
	$(IDRIS) --install $(PACKAGE)

test: build
	$(IDRIS) --testpkg $(PACKAGE)

build: TAP.idr
	$(IDRIS) --build $(PACKAGE)

clean:
	$(IDRIS) --clean $(PACKAGE)
