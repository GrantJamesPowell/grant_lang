Definitions.

FLOAT      = [0-9]+\.[0-9]+
INT        = [0-9]+
BOOL       = (true|false)
WHITESPACE = [\s\t\n\r]
COMPARATOR = (<|<=|==|>=|>)

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
\+ : {token, {'+', TokenLine}}.
\* : {token, {'*', TokenLine}}.
-  : {token, {'-', TokenLine}}.
\/ : {token, {'/', TokenLine}}.

% Comparisons
{COMPARATOR} : {token, {list_to_atom(TokenChars), TokenLine}}.

% Assignment
= : {token, {'=', TokenLine}}.

Erlang code.
