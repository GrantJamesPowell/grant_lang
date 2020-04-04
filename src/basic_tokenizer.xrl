Definitions.

FLOAT      = [0-9]+\.[0-9]+
INT        = [0-9]+
WHITESPACE = [\s\t\n\r]

Rules.

{WHITESPACE}+ : skip_token.

% Literals
{FLOAT}       : {token, {float, TokenLine, list_to_float(TokenChars)}}.
{INT}         : {token, {int, TokenLine, list_to_integer(TokenChars)}}.

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
== : {token, {'==', TokenLine}}.

% Assignment
= : {token, {'=', TokenLine}}.

Erlang code.
