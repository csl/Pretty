CC=gcc
COFLAGS=
CWFLAGS=
CIFLAGS=
CMFLAGS=
CFLAGS = $(CWFLAGS) $(COFLAGS) $(CIFLAGS) $(CMFLAGS)
pretty:		pretty.o symbol.o init.o
			$(CC) $(CFLAGS) -o pretty $<
.c.o:
			$(CC) $(CFLAGS) -c $<
pretty.c:	pretty.l
			flex -o pretty.c pretty.l
