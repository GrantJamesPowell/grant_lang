Nonterminals statement statements expression.
Terminals int float bool statement_end.

Rootsymbol statements.

statements -> statement statement_end statements : ['$1' | '$3'].
statements -> statement statement_end : ['$1'].

statement -> int : extract_token('$1').
statement -> bool : extract_token('$1').
statement -> float : extract_token('$1').

expression -> int : extract_token('$1').
expression -> bool : extract_token('$1').
expression -> float : extract_token('$1').

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
