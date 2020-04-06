Definitions.

FLOAT      = -?[0-9]+\.[0-9]+
INT        = -?[0-9]+
WHITESPACE = [\s\t\n\r]
IDENTIFIER = [a-zA-Z]+[a-zA-Z0-9]*
STRING = ".*"
BLOCK_COMMENT = /\*(.|\n)*\*/
INLINE_COMMENT = //.*\n

Rules.

% Comments

{INLINE_COMMENT} : skip_token.
{BLOCK_COMMENT} : skip_token.

% Literals
{STRING} : {token, {string, TokenLine, process_string_literal(TokenChars)}}.
{FLOAT}  : {token, {float, TokenLine, list_to_float(TokenChars)}}.
{INT}    : {token, {int, TokenLine, list_to_integer(TokenChars)}}.

%% Keywords

if    : {token, {'if', TokenLine}}.
else  : {token, {'else', TokenLine}}.
for   : {token, {'for', TokenLine}}.
while : {token, {while, TokenLine}}.
break : {token, {break, TokenLine}}.
nil   : {token, {nil, TokenLine}}.
true  : {token, {bool, TokenLine, true}}.
false : {token, {bool, TokenLine, false}}.
\.    : {token, {dot, TokenLine}}.
<-    : {token, {'<-', TokenLine}}.
;     : {token, {';', TokenLine}}.

% or equals
\|\|= : {token, {'||=', TokenLine}}.

% Increment / Decrement
\+\+  : {token, {'++', TokenLine}}.
--    : {token, {'--', TokenLine}}.

% Compare
==    : {token, {'==', TokenLine}}.
!=    : {token, {'!=', TokenLine}}.
<=    : {token, {'<=', TokenLine}}.
>=    : {token, {'>=', TokenLine}}.
<     : {token, {'<', TokenLine}}.
>     : {token, {'>', TokenLine}}.

% Bools
&&    : {token, {'&&', TokenLine}}.
\|\|  : {token, {'||', TokenLine}}.
!     : {token, {'!', TokenLine}}.

% Maps
&\{   : {token, {'&{', TokenLine}}.
=>    : {token, {'=>', TokenLine}}.

% Math
\*\*  : {token, {'**', TokenLine}}.
\*    : {token, {'*', TokenLine}}.
\/    : {token, {'/', TokenLine}}.
\+    : {token, {'+', TokenLine}}.
\-    : {token, {'-', TokenLine}}.

% Grouping
\[    : {token, {'[', TokenLine}}.
\]    : {token, {']', TokenLine}}.
\(    : {token, {'(', TokenLine}}.
\)    : {token, {')', TokenLine}}.
\{    : {token, {'{', TokenLine}}.
\}    : {token, {'}', TokenLine}}.
,     : {token, {',', TokenLine}}.

% Identifier
\${IDENTIFIER} : {token, {var, TokenLine, list_to_binary(TokenChars)}}.
{IDENTIFIER}   : {token, {identifier, TokenLine, list_to_binary(TokenChars)}}.

% Non significant whitespace
{WHITESPACE}+ : skip_token.

Erlang code.

process_string_literal(StringLiteral) ->
  list_to_binary(string:replace(StringLiteral, "\"", "", all)).

