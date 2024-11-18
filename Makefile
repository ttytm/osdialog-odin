OSDIALOG = $(MAKEDIR)/thirdparty/osdialog
SRCS = $(OSDIALOG)/osdialog.c $(OSDIALOG)/osdialog_win.c
OBJS = osdialog.obj osdialog_win.obj
LIBS = comdlg32.lib msvcrt.lib
TARGET = osdialog.lib

all: $(TARGET)

$(TARGET):
	@git submodule update --init --recursive
	@$(CC) /c $(SRCS)

clean:
	del *.obj
	del $(TARGET)
