
#include "global.h"

struct entry keywords[] = {
  { "auto", AUTO },
  { "break", BREAK},
  { "case", CASE},
  { "char", CHAR},
  { "const", CONST},
  { "continue", CONTINUE},
  { "default",DEFAULT},
  { "do", DO},
  { "double", DOUBLE},
  { "else", ELSE},
  { "enum", ENUM},
  { "extern",EXTERN},
  { "float", FLOAT},
  { "for", FOR},
  { "goto", GOTO},
  { "if", IF},
  { "int", INT},
  { "long", LONG},
  { "register", REGISTER},
  { "return", RETURN},
  { "short", SHORT},
  { "signed", SIGNED},
  { "sizeof", SIZEOF},
  { "static", STATIC},
  { "struct", STRUCT},
  { "switch", SWITCH},
  { "typedef", TYPEDEF},
  { "union", UNION},
  { "unsigned", UNSIGNED},
  { "void", VOID},
  { "volatile", VOLATILE},
  { "while", WHILE},
  { 0,     0 }
};

void init()
{
	int i=0;
	while (keywords[i].token != 0)
	{
		insert(keywords[i].lexptr, keywords[i].token);
		i++;
	}

}
