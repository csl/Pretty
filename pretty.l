%{
#include<stdio.h>
#include<stdlib.h>
#define INDENT (4)
int line = 1;
int column = 4;
int paren = 0;
%}


%%


%%

void indent()
{
	printf("\n%-*d", column, line++);
}

int main()
{
	printf("<html><pre>\n");
	indent();
	yylex();
	printf("\n</pre></html>");
	return 0;
}
