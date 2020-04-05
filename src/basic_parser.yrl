Nonterminals list block variable map_pairs expression expressions.
Terminals '[' ']' '(' ')' '{' '}' ','
   var int float bool string operator
   map_start fat_right_arrow
   if_block else_block statement_end.

Rootsymbol expressions.

expressions -> expression statement_end expressions : ['$1' | '$3'].
expressions -> expression statement_end : ['$1'].
expressions -> expression : ['$1'].

% Literals
expression -> int : extract_token('$1').
expression -> bool : extract_token('$1').
expression -> float : extract_token('$1').
expression -> string : extract_token('$1').

% Variables
expression -> variable '[' expression ']' : {index, '$1', '$3'}.
expression -> variable : '$1'.
variable -> var : {var, extract_token('$1')}.

% Operators
expression -> expression operator expression : {extract_token('$2'), '$1', '$3'}.
expression -> '(' expression ')' : '$2'.

% If
expression -> if_block expression block else_block block : {if_expression, '$2', '$3', '$5'}.
expression -> if_block expression block : {if_expression, '$2', '$3', [nil]}.

% code blocks
block -> '{' expressions '}' : '$2'.
block -> '{' '}' : [nil].

% Maps
expression -> map_start map_pairs : {map, '$2'}.
map_pairs -> ',' expression fat_right_arrow expression map_pairs : [{'$2', '$4'} | '$5'].
map_pairs -> expression fat_right_arrow expression map_pairs : [{'$1', '$3'} | '$4'].
map_pairs -> '}' : [].

% List
expression -> '[' ']' : [].
expression -> '[' list ']' : '$2'.
list -> expression ',' list : ['$1' | '$3'].
list -> expression : ['$1'].


Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
