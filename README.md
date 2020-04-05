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

- [ ] Strings
  - [ ] Double quote
  - [ ] Single quote
  - [ ] Heredoc
  - [ ] escaped newlines
  - [ ] string concat (<<)
- [ ] Comparators
  - [x] > < <= >=
  - [ ] == !=
- [ ] Negative Numbers
- [ ] Maps
  - [ ] Literals
  - [ ] Dot access
- [ ] Arrays
  - [x] literals
  - [ ] numeric indexing ($arrays[10])
  - [ ] << (shovel) operator
  - [ ]
- [ ] If statements
- [ ] For loops
  - [ ] Break Statement
  - [ ] Return array of results
- [ ] While Loops
  - [ ] Break Statement
- [ ] Functions
  - [ ] Call "stdlib functions"
  - [ ] Define functions
  - [ ] Functions as values?
  - [ ] Anon funcs?

# DONE

- [x] Comments
  - [x] nested comments

## Sample

```grantscript
// I'm a comment!
/* I'm a block comment
see me span multiple lines */

// assignment
$foo <- [1,2,3];
$bar <- true || false;

// literals
$integer <- 1;
$float <- 1.0;
$negative_int <- -1;
$negative_float <- -1.0;
$string <- "foo";
$escaped_string <- "\"bar\"\n";
$multiline_string <- """
  foo
  bar
  baz
""";
$array <- [1,2,3];
$dict <- &{
  "foo" => "bar",
  "baz" => 1.0
  1 => 2,
  [1,2,3] => (4 + 5)
}

// indexing
$array[$index]
$dict[$key]
$dict.key

// comparison / boolean logic
$result <- (1 < 2) && (3 >= 5) || ( 5 != 6);

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
