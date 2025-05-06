# ****************************************************************************
# *                                                                          *
# *  vide4linux.mak                                                          *
# *  ==============                                                          *
# *                                                                          *
# ****************************************************************************

# ****************************************************************************
# *                                                                          *
# *  Define the name of the makefile.                                        *
# *                                                                          *
# ****************************************************************************

MAKNAM = vide4linux.mak

# ****************************************************************************
# *                                                                          *
# * TOOLS                                                                    *
# *                                                                          *
# ****************************************************************************

LDD = ldd

# ****************************************************************************
# *                                                                          *
# *  Define the directories in which to search for library files.            *
# *                                                                          *
# ****************************************************************************

LIBDRS =

# ****************************************************************************
# *                                                                          *
# *  Define the directories in which to search for include files.            *
# *                                                                          *
# ****************************************************************************

INCDRS =

# ****************************************************************************
# *                                                                          *
# *  Define the library files.                                               *
# *                                                                          *
# ****************************************************************************

LIBFLS =

# ****************************************************************************
# *                                                                          *
# *  Define the source files.                                                *
# *                                                                          *
# ****************************************************************************

SRCFLS = capturar_video.c

# ****************************************************************************
# *                                                                          *
# *  FFMPEG                                                                  *
# *                                                                          *
# ****************************************************************************

FFMPEG = ffmpeg

# ****************************************************************************
# *                                                                          *
# *  Define the object files.                                                *
# *                                                                          *
# ****************************************************************************

OBJFLS = capturar_video.o

# ****************************************************************************
# *                                                                          *
# *  Define the executable.                                                  *
# *                                                                          *
# ****************************************************************************

EXE    = capturar_video.exe

# ****************************************************************************
# *                                                                          *
# *  lib FFMPEG                                                              *
# *                                                                          *
# ****************************************************************************

PKG_CONFIG_PATH:=/usr/lib/x86_64-linux-gnu/pkgconfig
export PKG_CONFIG_PATH
FFMPEG_LIBS   = libavformat libavcodec libavutil libswscale libavdevice
FFMPEG_CFLAGS = $(shell /usr/bin/pkg-config --cflags $(FFMPEG_LIBS))
FFMPEG_LDLIBS = $(shell /usr/bin/pkg-config --libs $(FFMPEG_LIBS))

# ****************************************************************************
# *                                                                          *
# *  Define the compile and link options.                                    *
# *                                                                          *
# ****************************************************************************

CC     = gcc
LL     = gcc
CFLAGS = $(FFMPEG_CFLAGS)
LFLAGS = $(FFMPEG_LDLIBS)

# ****************************************************************************
# *                                                                          *
# *  Define the rules.                                                       *
# *                                                                          *
# ****************************************************************************

$(EXE): $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) $(LIBDRS) $(LIBFLS) $(LFLAGS)

.c.o:
	$(CC) $(CFLAGS) -o $@ -c $(INCDRS) $<

all:
	make -f $(MAKNAM) clean
	make -f $(MAKNAM) depend

depend:
	makedepend $(INCDRS) -f $(MAKNAM) $(SRCFLS)
	make -f $(MAKNAM) $(EXE)

run: $(EXE)
	./$(EXE)

free: $(EXE)
	valgrind --leak-check=full ./$(EXE)

lsformats:
	$(FFMPEG) -f v4l2 -list_formats all -i /dev/video0

lsdevices:
	$(FFMPEG) -devices | grep v4l2

bear:
	$@ -- make -f $(MAKNAM) $(EXE)

# Alvo para verificar se o binário está linkado com libavdevice/libavformat/etc
ldd:
	$(LDD) $(EXE)

# Alvo que aceita argumento, por exemplo:
# make -f vide4linux.mak checklib LIB=avdevice
checklib:
	@$(LDD) $(EXE) | grep $(LIB) || echo "❌ $(LIB) não encontrado"

clean:
	-rm $(EXE)
	-rm $(OBJFLS)

# DO NOT DELETE THIS LINE -- make depend depends on it.
