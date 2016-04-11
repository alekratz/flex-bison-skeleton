#ifndef MATLAB_LEXER_HPP
#define MATLAB_LEXER_HPP

#include "driver.hpp"
#include "parser.hpp"

#ifndef __FLEX_LEXER_H
#define yyFlexLexer yyFlexLexer
#include <FlexLexer.h>
#undef yyFlexLexer
#endif

#define YY_DECL \
    yy::mylanguage_parser::symbol_type mylanguage_lexer::lex(mylanguage_driver& driver)
#define yyterminate() return yy::mylanguage_parser::make_END(loc);

class yyFlexLexer;

class mylanguage_lexer
    : public yyFlexLexer
{
public:
    mylanguage_lexer(std::istream *in = nullptr, std::ostream *out = nullptr)
        : yyFlexLexer(in, out)
    { }

public:
    yy::mylanguage_parser::symbol_type lex(mylanguage_driver& driver);
    // Location of the current token
    yy::location loc;

public:
    void begin_naked_args();
};

#endif
