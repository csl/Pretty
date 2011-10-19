%option noyywrap

%{
#include<stdio.h>
#include<stdlib.h>
#include "global.h"
#define INDENT (4)

%}

quote	\'
ditto	\"
back	\\
digit	[0-9]
exp	[eE][+-]{digit}+
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
{alpha}({alpha}|{digit})* {write_id();}
^#[^\n]* { write_directive(); }
"{" {write_begin();}
"}" {write_end();}
"(" {write_open();}
")" {write_close();}
"[" {write_bopen();}
"]" {write_bclose();}
";" {write_sep();}
"/*" { write_comment(); }
"//" { write_inline(); }
^#. { write_directive(); }
"(\t|\r|\n|\v|\f)" { }
"==" { write_op();}
"!=" { write_op();}
"=" { write_op();}
"+" { write_op();}
"-" { write_op();}
"*" { write_op();}
"/" { write_op();}
"%" { write_op();}
"<<" { write_op();}
">>" { write_op();}
"^" { write_op();}
"++" { write_op();}
"--" { write_op();}
"+=" { write_op();}
"-=" { write_op();}
"*=" { write_op();}
"/=" { write_op();}
"%=" { write_op();}
"&=" { write_op();}
"|=" { write_op();}
"^=" { write_op();}
"<<=" { write_op();}
">>=" { write_op();}
"~" { write_op();}
"|" { write_op();}
"&" { write_op();}
"||" { write_op();}
"&&" { write_op();}
">" { write_op();}
">=" { write_op();}
"<" { write_op();}
"<=" { write_op();}
"!" { write_op();}
":" { write_op();}
"?" { write_op();}

%%

extern struct entry symtable[];

int line = 1;
int column = 4;
int paren = 0;
int local_variables = 0;

void indent()
{ 
	printf("\n%-*d", column, line++);
}

void write_comment()
{ 
	char c, c1;
	printf("<font color=\"#00FF00\">/*");
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
    printf("<font color=\"#FF0000\">\"");
	write_html();	
    printf("\"</font>");

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

void write_directive()
{
    printf("<font color=\"#FF00FF\"><strong>");
    write_html();
    printf("</strong></font>");
}

void write_char()
{
    printf("<font color=\"brown\">'<u>");
	write_html();
    printf("</u>'</font>");
}

void write_oct()
{
   printf("<font color=\"brown\"><i>");
   write_html();
   printf("</i></font>");
}

void write_hex()
{
    printf("<font color=\"brown\"><i>");
    write_html();
    printf("</i></font>");
}

void write_int()
{
  printf("<font color=\"brown\"><i>");
  write_html();
  printf("</i></font>");
}

void write_fp()
{
  printf("<font color=\"brown\">");
  write_html();
  printf("</font>");
}

void write_id()
{
    char *s = yytext;
	int result = lookup(s);
	int i=0, set=0;

	if (result != 0)
	{
		if (symtable[result].token == ID)
		{
			//ID, 2nd meet
			printf("<a href=\"#");
			write_html();
			printf("\">");
			write_html();
			printf("</a>");
						
		}
		else
		{
			
			if (symtable[result].token == INT || symtable[result].token == CHAR || symtable[result].token == FLOAT || symtable[result].token == DOUBLE)
			{
				local_variables = 1;
			}

  			printf("<strong>");
  			write_html();
  			printf("</strong>");
		}
	}
	else
	{
		if (column == 4 || local_variables == 0)
		{
			insert(s, ID);
			local_variables = 0;
			//ID, first I meet
			printf("<a name=\"");
			write_html();
			printf("\"/>");
		}
		else
		{
			local_variables = 0;
			write_html();
		}
	}
}

void write_op()
{
  printf("<font color=\"#000000\"><strong>");
  write_html();
  printf("</strong></font>");
}

void write_inline()
{
  printf("<font color=\"green\">//");
  write_html();
  printf("</font>");
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
	init();
	printf("<html><pre>\n");
	indent();
	yylex();
	printf("\n</pre></html>");
	return 0;
}
