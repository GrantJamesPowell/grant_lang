Nonterminals program.
Terminals int float bool.

Rootsymbol program.

program -> int : extract_token('$1').
program -> float : extract_token('$1').
program -> bool : extract_token('$1').

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
