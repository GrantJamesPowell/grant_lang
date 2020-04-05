defmodule Basex do
  def tokenize(code) when is_binary(code) do
    code |> to_charlist() |> tokenize()
  end

  def tokenize(code) do
    {:ok, _tokens, _} = :basic_tokenizer.string(code)
  end

  def parse(code) do
    {:ok, tokens, _} = tokenize(code)
    :basic_parser.parse(tokens)
  end

  def eval(code) do
    {:ok, expressions} = parse(code)
    evalutate_expressions(expressions, %{vars: %{}})
  end

  def evalutate_expressions(expressions, state) do
    {_state, result} =
      Enum.reduce(expressions, {state, nil}, fn expression, {state, _} ->
        {:ok, state, result} = evalutate_expression(expression, state)
        {state, result}
      end)

    {:ok, result}
  end

  def evalutate_expression({:+, left, right}, state) do
    {:ok, state, lhs} = evalutate_expression(left, state)
    {:ok, state, rhs} = evalutate_expression(right, state)
    {:ok, state, lhs + rhs}
  end

  def evalutate_expression({:<-, {:var, var}, expression}, state) do
    {:ok, state, value} = evalutate_expression(expression, state)
    variables = Map.put(state.vars, var, value)
    {:ok, Map.put(state, :vars, variables), value}
  end

  def evalutate_expression({:var, var}, state) do
    {:ok, state, Map.fetch!(state.vars, var)}
  end

  def evalutate_expression(number, state) when is_number(number), do: {:ok, state, number}
end
