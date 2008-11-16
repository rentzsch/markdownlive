CC=cc -I. -L.
AR=/usr/bin/ar
RANLIB=/usr/bin/ranlib

BINDIR=/usr/local/bin
MANDIR=/usr/local/man
LIBDIR=/usr/local/lib
INCDIR=/usr/local/include

PGMS=markdown
SAMPLE_PGMS=mkd2html makepage
SAMPLE_PGMS+= theme
MKDLIB=libmarkdown.a
OBJS=mkdio.o markdown.o dumptree.o generate.o \
     resource.o docheader.o version.o toc.o xmlpage.o 

all: $(PGMS) $(SAMPLE_PGMS)

install: $(PGMS)
	/usr/bin/install -s -m 755 $(PGMS) $(BINDIR)
	/usr/bin/install -m 444 $(MKDLIB) $(LIBDIR)
	/usr/bin/install -m 444 mkdio.h $(INCDIR)

install.everything: install install.samples install.man

install.samples: $(SAMPLE_PGMS) install
	/usr/bin/install -s -m 755 $(SAMPLE_PGMS) $(BINDIR)
	/Users/wolf/code/trac/cocoa/MarkdownLive/discount-1.3.0/config.md $(MANDIR)/man1
	/usr/bin/install -m 444 theme.1 $(MANDIR)/man1

install.man:
	/Users/wolf/code/trac/cocoa/MarkdownLive/discount-1.3.0/config.md $(MANDIR)/man3
	/usr/bin/install -m 444 mkd-functions.3 markdown.3 $(MANDIR)/man3
	for x in mkd_text mkd_in mkd_string; do \
	    ( echo '.\"' ; echo ".so man3/markdown.3" ) > $(MANDIR)/man3/$$x.3;\
	done
	for x in mkd_compile mkd_style mkd_generatehtml mkd_cleanup mkd_doc_title mkd_doc_author mkd_doc_date; do \
	    ( echo '.\"' ; echo ".so man3/mkd-functions.3" ) > $(MANDIR)/man3/$$x.3; \
	done
	/Users/wolf/code/trac/cocoa/MarkdownLive/discount-1.3.0/config.md $(MANDIR)/man7
	/usr/bin/install -m 444 markdown.7 mkd-extensions.7 $(MANDIR)/man7
	/Users/wolf/code/trac/cocoa/MarkdownLive/discount-1.3.0/config.md $(MANDIR)/man1
	/usr/bin/install -m 444 markdown.1 $(MANDIR)/man1

install.everything: install install.man

version.o: version.c VERSION
	$(CC) -DVERSION=\"`cat VERSION`\" -c version.c

markdown: main.o $(MKDLIB)
	$(CC) -o markdown main.o -lmarkdown 

# example programs
theme:  theme.o $(MKDLIB)
	$(CC) -o theme theme.o -lmarkdown 


mkd2html:  mkd2html.o $(MKDLIB)
	$(CC) -o mkd2html mkd2html.o -lmarkdown 

makepage:  makepage.c $(MKDLIB)
	$(CC) -o makepage makepage.c -lmarkdown 

main.o: main.c mkdio.h config.h
	$(CC) -I. -c main.c

$(MKDLIB): $(OBJS)
	$(AR) crv $(MKDLIB) $(OBJS)
	$(RANLIB) $(MKDLIB)

test:	$(PGMS) echo
	@for x in tests/*.t; do \
	    sh $$x || exit 1; \
	done

echo:   echo.c
	$(CC) -o echo echo.c
	
clean:
	rm -f $(PGMS) $(SAMPLE_PGMS) *.o $(MKDLIB)

distclean spotless: clean
	rm -f Makefile version.c markdown.1 config.cmd config.sub config.h config.mak config.log config.md

markdown.o: markdown.c config.h cstring.h markdown.h
generate.o: generate.c config.h cstring.h markdown.h
dumptree.o: dumptree.c cstring.h markdown.h
mkdio.o: mkdio.c mkdio.h cstring.h config.h
xmlpage.o: xmlpage.c mkdio.h cstring.h config.h
toc.o: toc.c mkdio.h cstring.h config.h
