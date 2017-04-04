.PHONY: test clean install

LIB_PKG = TAP.ipkg
BIN_PKG = Draft.ipkg

IDRIS = idris
BUILD = $(IDRIS) --build
CLEAN = $(IDRIS) --clean
TEST = $(IDRIS) --testpkg

all: install

repl:
	$(IDRIS)

install: build
	$(IDRIS) --install $(LIB_PKG)

test: build
	$(TEST) $(LIB_PKG)
	$(TEST) $(BIN_PKG)

build: $(LIB_PKG) $(BIN_PKG)
	$(BUILD) $(LIB_PKG)
	$(BUILD) $(BIN_PKG)

clean: $(LIB_PKG) $(BIN_PKG)
	$(CLEAN) $(LIB_PKG)
	$(CLEAN) $(BIN_PKG)
