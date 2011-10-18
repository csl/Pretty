%option noyywrap

%{
#include<stdio.h>
#include<stdlib.h>
#define INDENT (4)

%}


quote	\'
ditto	\"
back	\\
digit	[0-9]
exp	[eE][+-]digit+
hex	[{digit}a-zA-Z]
alpha	[a-zA-Z_]
ch	[^\n\'"]

%%
{ditto}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{quote})*{ditto} { write_string(); }
{quote}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{ditto})*{quote} { write_char(); }
0({digit})+ {write_oct();}
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
"//" { write_inline(); }
"(\t|\r|\n)" { }



%%

int line = 1;
int column = 4;
int paren = 0;

void indent()
{ 
	printf("\n%-*d", column, line++);
}

void write_comment()
{ 
	char c, c1;
	printf("<font color=¡¦#00FF00¡¦>/*");
loop:
	while ((c = input()) != '*' && c != 0)
		write_html_char(c);

	write_html_char('*');
	if ((c1 = input()) != '/' && c != 0)
	{ 
		unput(c1);
		goto loop;
	}

	if (c != 0)
		write_html_char(c1);
	
	printf("</font>");
}


void write_html_char(int c)
{ 
	switch (c)
	{ 
		case '<': printf("&lt;"); break;
		case '>': printf("&gt;"); break;
		case '"': printf("&quot;"); break;
		case '&': printf("&amp;"); break;
		default: 
			putchar(c);
	}
}

void write_string()
{
	char *s = yytext;

}

void write_html()
{ 
	char *s = yytext;
	while (*s)
		write_html_char(*s++);
}

void write_sep()
{ 
	write_html();
	if (!paren)
	  indent();
	else
	  putchar(' ');
}

void write_begin()
{ 
	indent();
	write_html();
	column += INDENT;
	indent();
}

void write_end()
{ 
	column -= INDENT;
	indent();
	write_html();
	indent();
}

void write_open()
{ 
	write_html();
	putchar(' ');
	paren++;
}

void write_close()
{ 
	write_html();
	putchar(' ');
	paren--;
}

void write_char()
{

}

void write_oct()
{

}

void write_hex()
{

}

void write_int()
{

}

void write_fp()
{

}

void write_id()
{

}

void write_inline()
{

}

void write_bopen()
{ 
	write_html();
	putchar(' ');
	paren++;
}

void write_bclose()
{ 
	write_html();
	putchar(' ');
	paren--;
}


int main()
{
	printf("<html><pre>\n");
	indent();
	yylex();
	printf("\n</pre></html>");
	return 0;
}
