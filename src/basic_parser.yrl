Nonterminals variable block map_pairs expression expressions comma_seperated_expressions.
Terminals '[' ']' '(' ')' '{' '}' ',' '<-'
   var int float nil bool string operator identifier
   map_start fat_right_arrow dot
   'if' 'else' 'for' statement_end.

Rootsymbol expressions.

expressions -> expression statement_end expressions : ['$1' | '$3'].
expressions -> expression statement_end : ['$1'].
expressions -> expression : ['$1'].

% Literals
expression -> nil      : nil.
expression -> int      : extract_token('$1').
expression -> bool     : extract_token('$1').
expression -> float    : extract_token('$1').
expression -> string   : extract_token('$1').
expression -> variable : '$1'.
variable   -> var      : {var, extract_token('$1')}.

% Indexing
expression -> expression '[' expression ']' : {index, '$1', '$3'}.

% Dot Access
expression -> expression dot identifier : {dot, '$1', extract_token('$3')}.

% If
expression -> 'if' expression block 'else' block : {'if', '$2', '$3', '$5'}.
expression -> 'if' expression block              : {'if', '$2', '$3', [nil]}.

% For
expression -> 'for' variable '<-' expression block : {'for', {'$2', {var, unused}}, '$4', '$5'}.
expression -> 'for' variable ',' variable '<-' expression block : {'for', {'$2', '$4'}, '$6', '$7'}.

% Code Blocks
block -> '{' expressions '}' : '$2'.
block -> '{' '}' : [nil].

% Maps
expression -> map_start map_pairs : {map, '$2'}.
map_pairs -> ',' expression fat_right_arrow expression map_pairs : [{'$2', '$4'} | '$5'].
map_pairs -> expression fat_right_arrow expression map_pairs : [{'$1', '$3'} | '$4'].
map_pairs -> '}' : [].

% Arrays
expression -> '[' ']' : {array, []}.
expression -> '[' comma_seperated_expressions ']' : {array, '$2'}.
comma_seperated_expressions -> expression ',' comma_seperated_expressions : ['$1' | '$3'].
comma_seperated_expressions -> expression : ['$1'].

% Operators
expression -> expression operator expression : {extract_token('$2'), '$1', '$3'}.
expression -> expression '<-' expression : {'<-', '$1', '$3'}.
expression -> '(' expression ')' : '$2'.

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
