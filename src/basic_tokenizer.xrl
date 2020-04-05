Definitions.

FLOAT      = [0-9]+\.[0-9]+
INT        = [0-9]+
BOOL       = (true|false)
WHITESPACE = [\s\t\n\r]
COMPARATOR = (<|<=|==|>=|>)
ARITHMETIC_OPERATOR = (\+|\*|\/|-)

Rules.

{WHITESPACE}+ : skip_token.
; : {token, {statement_end, TokenLine}}.

% Literals
{FLOAT}       : {token, {float, TokenLine, list_to_float(TokenChars)}}.
{INT}         : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
{BOOL}        : {token, {bool, TokenLine, list_to_existing_atom(TokenChars)}}.

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

% Comparisons
{COMPARATOR} : {token, {comparator, TokenLine, list_to_atom(TokenChars)}}.

% Assignment
= : {token, {'=', TokenLine}}.

Erlang code.
