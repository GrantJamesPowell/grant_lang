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
    {:ok, _state, result} = evalutate_expressions(expressions, %{vars: %{}})
    {:ok, result}
  end

  def evalutate_expressions(expressions, state) do
    {state, result} =
      Enum.reduce(expressions, {state, nil}, fn expression, {state, _} ->
        {:ok, state, result} = evalutate_expression(expression, state)
        {state, result}
      end)

    {:ok, state, result}
  end

  def evalutate_expression({operator, left, right}, state)
      when operator in [:+, :-, :*, :/, :"**", :<, :>, :<=, :>=, :!=, :==, :||, :&&] do
    {:ok, state, lhs} = evalutate_expression(left, state)
    {:ok, state, rhs} = evalutate_expression(right, state)

    result =
      case operator do
        :"**" -> :math.pow(lhs, rhs)
        :|| -> lhs || rhs
        :&& -> lhs && rhs
        _ -> apply(Kernel, operator, [lhs, rhs])
      end

    {:ok, state, result}
  end

  def evalutate_expression({:<-, {:var, var}, expression}, state) do
    {:ok, state, value} = evalutate_expression(expression, state)
    variables = Map.put(state.vars, var, value)
    {:ok, Map.put(state, :vars, variables), value}
  end

  def evalutate_expression({:var, var}, state) do
    {:ok, state, Map.fetch!(state.vars, var)}
  end

  def evalutate_expression(
        {:if_expression, condition_expression, success_block, else_block},
        state
      ) do
    {:ok, state, condition} = evalutate_expression(condition_expression, state)

    if condition do
      evalutate_expressions(success_block, state)
    else
      evalutate_expressions(else_block, state)
    end
  end

  def evalutate_expression(number, state) when is_number(number), do: {:ok, state, number}
  def evalutate_expression(string, state) when is_binary(string), do: {:ok, state, string}
  def evalutate_expression(bool, state) when is_boolean(bool), do: {:ok, state, bool}
  def evalutate_expression(nil, state), do: {:ok, state, nil}
end
