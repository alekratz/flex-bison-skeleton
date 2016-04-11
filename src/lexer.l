%option c++ noyywrap nounput batch debug noinput

%{
#include "driver.hpp"
#include "lexer.hpp"
#include "parser.hpp"

#include <sstream>
#include <string>
#include <cstdint>

#define YY_USER_ACTION loc.columns(yyleng);

#undef yywrap
#define yywrap() 1
%}

D           [0-9]
L           [a-zA-Z_]
E           [DdEe][+-]?{D}+

identifier  {L}({L}|{D})*
num         {D}+
comment     %[^\n]*\n
newline     \n
newlines    {newline}+
ws          [\t ]+

dot         \.
continue    \.\.\.

%special transpose string_lit naked_args naked_args_start

%%
{comment}               { loc.lines(1); return yy::mylanguage_parser::make_NEWLINE(loc); }

{identifier}            { return yy::mylanguage_parser::make_IDENTIFIER(yytext, loc); }

{D}+({E})?              { 
                            std::stringstream ss(yytext);
                            double result;
                            ss >> result;
                            return yy::mylanguage_parser::make_CONSTANT(result, loc);
                        }
                        
{D}*{dot}{D}+({E})?     { 
                            std::stringstream ss(yytext);
                            double result;
                            ss >> result;
                            return yy::mylanguage_parser::make_CONSTANT(result, loc);
                        }
                        
{D}+{dot}{D}*({E})?     { 
                            std::stringstream ss(yytext);
                            double result;
                            ss >> result;
                            return yy::mylanguage_parser::make_CONSTANT(result, loc);
                        }

"\"[^\"\n]*\""          { return yy::mylanguage_parser::make_STRING_LITERAL(yytext, loc); }

"<="                    { return yy::mylanguage_parser::make_LE_OP(loc); }
">="                    { return yy::mylanguage_parser::make_GE_OP(loc); }
"=="                    { return yy::mylanguage_parser::make_EQ_OP(loc); }
"~="                    { return yy::mylanguage_parser::make_NE_OP(loc); }
"~"                     { return yy::mylanguage_parser::make_TILDE(loc); }
";"                     { return yy::mylanguage_parser::make_SEMICOLON(loc); }
","                     { return yy::mylanguage_parser::make_COMMA(loc); }
":"                     { return yy::mylanguage_parser::make_COLON(loc); }
"="                     { return yy::mylanguage_parser::make_EQUALS(loc); }
"("                     { return yy::mylanguage_parser::make_LPAREN(loc); }
")"                     { return yy::mylanguage_parser::make_RPAREN(loc); }
"["                     { return yy::mylanguage_parser::make_LBRACKET(loc); }
"]"                     { return yy::mylanguage_parser::make_RBRACKET(loc); }
"{"                     { return yy::mylanguage_parser::make_LBRACE(loc); }
"}"                     { return yy::mylanguage_parser::make_RBRACE(loc); }
"&&"                    { return yy::mylanguage_parser::make_AMP(loc); }
"||"                    { return yy::mylanguage_parser::make_VBAR(loc); }
"&"                     { return yy::mylanguage_parser::make_AMP(loc); }
"|"                     { return yy::mylanguage_parser::make_VBAR(loc); }
"-"                     { return yy::mylanguage_parser::make_MINUS(loc); }
"+"                     { return yy::mylanguage_parser::make_PLUS(loc); }
"*"                     { return yy::mylanguage_parser::make_TIMES(loc); }
"/"                     { return yy::mylanguage_parser::make_FSLASH(loc); }
"\\"                    { return yy::mylanguage_parser::make_BSLASH(loc); }
"<"                     { return yy::mylanguage_parser::make_LT_OP(loc); }
">"                     { return yy::mylanguage_parser::make_GT_OP(loc); }
"^"                     { return yy::mylanguage_parser::make_HAT(loc); }
"."                     { return yy::mylanguage_parser::make_DOT(loc); }
{newlines}              { loc.lines(yyleng); return yy::mylanguage_parser::make_NEWLINE(loc); }
{ws}                    

.                       {  }
%{
    loc.step();
%}

%%

int yyFlexLexer::yylex()
{
    assert(false && "yyFlexLexer::yylex() called; this should not happen");
    return 0;
}
