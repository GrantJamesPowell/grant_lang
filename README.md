# Basex

A BASIC interperter written in Elxiir

Basic Lang Spec
http://media.salford-systems.com/pdf/spm7/BasicProgLang.pdf

Good articles
https://andrealeopardi.com/posts/tokenizing-and-parsing-in-elixir-using-leex-and-yecc/

Understanding Parser Basics
https://lark-parser.readthedocs.io/en/latest/parsers/

The Elixir Parser
https://github.com/elixir-lang/elixir/blob/master/lib/elixir/src/elixir_parser.yrl

Notes

Vocab:
A lexer will tokenize a sequence of bytes.

The syntax of a leex rule is this:

Regular expression : Erlang code.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `basex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:basex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/basex](https://hexdocs.pm/basex).

