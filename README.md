# Basex

A BASIC interperter written in Elxiir

Basic Lang Spec
http://media.salford-systems.com/pdf/spm7/BasicProgLang.pdf
https://en.wikipedia.org/wiki/BASIC
https://en.wikipedia.org/wiki/Tiny_BASIC

Good articles
https://andrealeopardi.com/posts/tokenizing-and-parsing-in-elixir-using-leex-and-yecc/

Understanding Parser Basics
https://lark-parser.readthedocs.io/en/latest/parsers/

The Elixir Parser
https://github.com/elixir-lang/elixir/blob/master/lib/elixir/src/elixir_parser.yrl

The Elixir Tokenizer
https://github.com/elixir-lang/elixir/blob/master/lib/elixir/src/elixir_tokenizer.erl

Building an interperter
https://ruslanspivak.com/lsbasi-part1/

Notes

Vocab:
A lexer will tokenize a sequence of bytes.

The syntax of a leex rule is this:

Regular expression : Erlang code.

# TODO

- [x] Comments
  - [ ] nested comments
- [ ] Strings
  - [ ] Double quote
  - [ ] Single quote
  - [ ] Heredoc
  - [ ] escaped newlines
- [ ] Negative Numbers
- [ ] Maps
  - [ ] Literals
  - [ ] Dot access
- [ ] Arrays
  - [ ] << (shovel) operator
- [ ] If statements
- [ ] For loops
  - [ ] Break Statement
- [ ] While Loops
- [ ] Functions
  - [ ] Call "stdlib functions"
  - [ ] Define functions
  - [ ] Functions as values?
  - [ ] Anon funcs?

## Sample

```grantscript
// I'm a comment!
/* I'm a block comment
see me span multiple lines */

// assignment
$foo <- [1,2,3];
$bar <- true || false;

// while loop
while ($bar) {
  // if statement
  if ($RAND > 0.5) { break; };
};

// for loop
for ($i <= $foo) {
  if ($i > 2) { @echo($i) } else { break; };
};

// assignment from an if statement
$result <- if ($RAND > 0.5) { 4; } else { 5; };
```
