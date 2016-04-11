#ifndef MATLAB2R_DRIVER_HPP
#define MATLAB2R_DRIVER_HPP 

#include "types.hpp"
#include "parser.hpp"
#include "lexer.hpp"
// #include "ast.hpp"
#include <string>
#include <iostream>

class mylanguage_driver
{
public:
    mylanguage_driver()
        : streamname()
        , lexer(nullptr)
        , trace_scanning(false)
        , trace_parsing(false)
    { }
    virtual ~mylanguage_driver() = default;

public:
    bool parse_stream(std::istream& in, cstref streamname, std::ostream& out = std::cout);
    bool parse_string(cstref line, cstref sname, std::ostream& out = std::cout);
    bool parse_file(cstref filename, std::ostream& out = std::cout);
    void error(const yy::location& l, cstref m, cstref t);
    void error(const yy::location& l, cstref m);
    void error(cstref m);

public:
    std::string streamname;
    mylanguage_lexer *lexer;
    // ast::statement_list_p ast;

    bool trace_scanning;
    bool trace_parsing;
};

#endif
