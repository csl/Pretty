CC=gcc
COFLAGS=
CWFLAGS=
CIFLAGS=
CMFLAGS=
CFLAGS = $(CWFLAGS) $(COFLAGS) $(CIFLAGS) $(CMFLAGS)
pretty:		pretty.o symbol.o init.o
			$(CC) $(CFLAGS) -o pretty pretty.o symbol.o init.o
.c.o:
			$(CC) $(CFLAGS) -c $<
pretty.c:	pretty.l
			flex -o pretty.c pretty.l
clean:
		rm *.o pretty
