defmodule Basex do
  def tokenize(code) when is_binary(code) do
    code |> to_charlist() |> tokenize()
  end

  def tokenize(code) do
    {:ok, tokens, _} = :basic_tokenizer.string(code)
  end

  def parse(code) do
    {:ok, tokens, _} = tokenize(code)
    {:ok, result} = :basic_parser.parse(tokens)
    result
  end
end
