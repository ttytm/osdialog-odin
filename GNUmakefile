MODULE_ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OSDIALOG := $(MODULE_ROOT)/thirdparty/osdialog
CFLAGS = -g -Wall -Wextra -std=c99 -pedantic
SOURCES+= $(OSDIALOG)/osdialog.c

# TODO: specify output locations to allow `make -f osdialog/Makefile` from foreign directories.
ifeq ($(OS),Windows_NT)
	LDFLAGS += -lcomdlg32
	SOURCES += $(OSDIALOG)/osdialog_win.c
else ifeq ($(shell uname),Darwin)
	LDFLAGS += -framework AppKit
	SOURCES += $(OSDIALOG)/osdialog_mac.m
	CFLAGS += -mmacosx-version-min=10.7
else
	CFLAGS += $(shell pkg-config --cflags gtk+-3.0)
	LDFLAGS += $(shell pkg-config --libs gtk+-3.0)
	SOURCES += $(OSDIALOG)/osdialog_gtk3.c
endif

all:
	@echo "Preparing osdialog C binding." \
	&& git submodule update --init --recursive \
	&& $(CC) $(CFLAGS) -c $(SOURCES) $(LDFLAGS) \
	&& echo "Done."
