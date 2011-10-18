%{
#include<stdio.h>
#include<stdlib.h>

#define INDENT (4)
int line = 1;
int column = 4;
int paren = 0;
%}

quote	'
ditto	"
back	\
digit	[0-9]
exp		[eE][+-]digit+
hex		[{digit}a-zA-Z]
alpha	[a-zA-Z_]
ch		[^\n\'"]

%%
{ditto}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{quote})*ditto { write_string(); }
{quote}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{ditto})*quote { write_char(); }
0(0|1|2|3|4|5|6|7)+ {write_oct();}
0(x|X){hex}+ { write_hex(); }
{digit}+ {write_int();}
{digit}*.{digit}*({exp}) {write_fp();}
{alpha}(alpha|digit)* {write_id();}
"{" {write_begin();}
"}" {write_end();}
"(" {write_open();}
")" {write_close();}
"[" {write_bopen();}
"]" {write_bclose();}
";" {write_sep();}
"/*" { write_comment(); }

%%

int main()
{
	printf("<html><pre>\n");
	indent();
	yylex();
	printf("\n</pre></html>");
	return 0;
}
