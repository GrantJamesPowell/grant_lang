Definitions.

FLOAT      = [0-9]+\.[0-9]+
INT        = [0-9]+
BOOL       = (true|false)
WHITESPACE = [\s\t\n\r]
COMPARATOR = (<|<=|!=|==|>=|>)
ARITHMETIC_OPERATOR = (\*\*|\+|\*|\/|-)
BOOLEAN_OPERATOR = (&&|\|\|)
IDENTIFIER = \$[a-zA-Z]+[a-zA-Z0-9]*
STRING = ".*"
BLOCK_COMMENT = /\*(.|\n)*\*/
INLINE_COMMENT = //.*\n

Rules.

{INLINE_COMMENT} : skip_token.
{BLOCK_COMMENT} : skip_token.

if : {token, {if_block, TokenLine}}.

{WHITESPACE}+ : skip_token.
; : {token, {statement_end, TokenLine}}.

% Assignment
<- : {token, {operator, TokenLine, list_to_atom(TokenChars)}}.
{IDENTIFIER} : {token, {var, TokenLine, list_to_binary(TokenChars)}}.

% Literals
{STRING} : {token, {string, TokenLine, process_string_literal(TokenChars)}}.
{FLOAT}  : {token, {float, TokenLine, list_to_float(TokenChars)}}.
{INT}    : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
{BOOL}   : {token, {bool, TokenLine, list_to_existing_atom(TokenChars)}}.

% Groupings
\[ : {token, {'[', TokenLine}}.
\] : {token, {']', TokenLine}}.
\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.
\{ : {token, {'{', TokenLine}}.
\} : {token, {'}', TokenLine}}.
,  : {token, {',', TokenLine}}.

% Operators
{ARITHMETIC_OPERATOR} : {token, {operator, TokenLine, list_to_atom(TokenChars)}}.
{BOOLEAN_OPERATOR} : {token, {operator, TokenLine, list_to_atom(TokenChars)}}.
{COMPARATOR} : {token, {operator, TokenLine, list_to_atom(TokenChars)}}.

Erlang code.

process_string_literal(StringLiteral) ->
  list_to_binary(string:replace(StringLiteral, "\"", "", all)).

