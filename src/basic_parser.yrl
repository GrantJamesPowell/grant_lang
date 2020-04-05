Nonterminals list expression expressions.
Terminals '[' ']' '(' ')' ',' var int float bool comparator operator statement_end.

Rootsymbol expressions.

expressions -> expression statement_end expressions : ['$1' | '$3'].
expressions -> expression statement_end : ['$1'].

expression -> expression operator expression : {extract_token('$2'), '$1', '$3'}.
expression -> '(' expression ')' : '$2'.

% List
expression -> '[' ']' : [].
expression -> '[' list ']' : '$2'.
list -> expression ',' list : ['$1' | '$3'].
list -> expression : ['$1'].

% Literals
expression -> var : {var, extract_token('$1')}.
expression -> int : extract_token('$1').
expression -> bool : extract_token('$1').
expression -> float : extract_token('$1').

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
