%skeleton "lalr1.cc"
%require "3.0.2"
%defines
%locations

%define parser_class_name {mylanguage_parser}
%define api.value.type variant
%define api.token.constructor
%define parse.assert
%define parse.trace
%define parse.error verbose
%define api.token.prefix {TOK_}

%code requires
{
    #include <string>
    #include <vector>
    #include <cstdint>
    #include <iostream>
    // #include "ast.hpp"
    class mylanguage_driver;
}

%code
{
    #include "driver.hpp"
    #include "lexer.hpp"
    #include <sstream>
    #undef yylex
    #define yylex driver.lexer->lex
}

%param { mylanguage_driver& driver }
// %printer { yyoutput << static_cast<std::underlying_type<ast::eostmt_type>::type>($$); } <ast::eostmt_type>;
%printer { yyoutput << $$; } <*>;

%initial-action
{
    // Initialize the initial location
    @$.begin.filename = @$.end.filename = &driver.streamname;
}

// Tokens
%token
    END     0       "end of file"
    NEWLINE 10      "newline"
    LE_OP
    GE_OP
    EQ_OP
    NE_OP
    TILDE
    SEMICOLON
    COMMA
    COLON
    EQUALS
    LPAREN
    RPAREN
    LBRACKET
    RBRACKET
    LBRACE
    RBRACE
    AMP
    MINUS
    PLUS
    TIMES
    FSLASH
    BSLASH
    LT_OP
    GT_OP
    HAT
    VBAR
    DOT

%token <std::string>        IDENTIFIER
%token <double>             CONSTANT
%token <std::string>        STRING_LITERAL
%token <std::string>        NAKED_ARG
// %type <mytype>              my_rule


%%

%start unit;

unit : %empty;

%%

void yy::mylanguage_parser::error(const location_type& l, const std::string& m)
{
    driver.error(l, m);
}