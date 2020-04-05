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
  - [x] Double quote single line
  - [ ] Heredoc
  - [ ] escaped newlines
  - [ ] escaped quotes (the current processer is striping the out with `replace`)
  - [ ] string concat (<<)
- [ ] Negative Numbers
- [ ] Maps
  - [ ] Literals
  - [ ] Dot access
- [ ] Arrays
  - [x] literals
  - [ ] numeric indexing ($arrays[10])
  - [ ] << (shovel) operator
- [ ] For loops
  - [ ] for ($val <- $array) { $val + 1 } // $array
  - [ ] for ($val <- $map) { $val + 1 } // $map
  - [ ] for ($index, $val <- $array) { $val + 1 } // $array
  - [ ] for ($key, $val <- $map) { $val + 1 } // $map
- [ ] While Loops
  - [ ] Break Statement
- [ ] Functions
  - [ ] Call "stdlib functions"
  - [ ] Define functions
  - [ ] Functions as values?
  - [ ] Anon funcs?
- [ ] Have && and || short circuit
- [ ] ! negation operator
- [ ] $foo++ $foo-- operators
- [ ] $foo ||= $bar operator
- [ ] REPL

# DONE

- [x] Comments
  - [x] nested comments
- [x] Comparators / Boolean Logic
  - [x] > < <= >=
  - [x] == !=
  - [x] && ||
- [x] Math operators
  - [x] `+ - / * **`
- [x] If statements
  - [x] else

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
$dict.key // only for string keys

// comparison / boolean logic
$result <- (1 < 2) && (3 >= 5) || ( 5 != 6);

// if statement 
if (true || false) { "foo"; } else { "bar"; };

// while loop
while ($bar) { if (true) { break; }; };

// for loop
for ($i <= $foo) {
  if ($i > 2) { std_lib.echo($i) } else { $i };
};

// for loops as `map`
$result <- for ($i <- [1,2,3]) { $i + 1 } // $result == [2,3,4]

// assignment from an if statement
$result <- if ($RAND > 0.5) { 4; } else { 5; };
```

## General Notes

- Comments were the first time I had to deal with significant whitespace, "//" comments are ended by a new line, and it took me a minute to figure that one out 
- String escaping is really really hard...
