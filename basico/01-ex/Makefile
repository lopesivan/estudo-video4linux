
LIBDRS =

LIBFLS =

SRCFLS = video_frames.c\
         $(ALGOWC_TOPDIR)/source/list.c \
         $(ALGOWC_TOPDIR)/source/frames.c

VIDEO = ./arquivo.mp4
FFPROBE = ffprobe
FFPROBE_OPT = -v error \
			  -count_frames \
			  -select_streams v:0 \
			  -show_entries stream=nb_frames \
			  -of default=nw=1:nk=1

OBJFLS = video_frames.o\
         $(ALGOWC_TOPDIR)/source/list.o \
         $(ALGOWC_TOPDIR)/source/frames.o

EXE    = video_frames.exe

PKG_CONFIG_PATH:=/usr/lib/x86_64-linux-gnu/pkgconfig
export PKG_CONFIG_PATH

FFMPEG_LIBS   = libavformat libavcodec libavutil libswscale
FFMPEG_CFLAGS = $(shell /usr/bin/pkg-config --cflags $(FFMPEG_LIBS))
FFMPEG_LDLIBS = $(shell /usr/bin/pkg-config --libs $(FFMPEG_LIBS))

CC     = gcc
LL     = gcc
CFLAGS = $(FFMPEG_CFLAGS) $(FREETYPE2_CFLAGS)
LFLAGS = $(FFMPEG_LDLIBS) $(FREETYPE2_LDLIBS)

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
	./$(EXE) $(VIDEO)

free: $(EXE)
	valgrind --leak-check=full ./$(EXE) $(VIDEO)

frames:
	$(FFPROBE) $(FFPROBE_OPT) $(VIDEO)

clean:
	-rm $(EXE)
	-rm $(OBJFLS)
