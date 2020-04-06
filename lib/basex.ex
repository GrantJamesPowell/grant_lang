defmodule Basex do
  import :array, only: [is_array: 1]

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

  def evalutate_expression({:while, condition_expression, block}, state) do
    {:ok, state, condition} = evalutate_expression(condition_expression, state)

    if condition do
      {:ok, state, result} = evalutate_expressions(block, state)

      if result == :break do
        {:ok, state, nil}
      else
        evalutate_expression({:while, condition_expression, block}, state)
      end
    else
      {:ok, state, nil}
    end
  end

  def evalutate_expression({:if, condition_expression, success_block, else_block}, state) do
    {:ok, state, condition} = evalutate_expression(condition_expression, state)

    if condition do
      evalutate_expressions(success_block, state)
    else
      evalutate_expressions(else_block, state)
    end
  end

  def evalutate_expression({:for, vars, source_expression, loop_expressions}, state) do
    {:ok, state, source} = evalutate_expression(source_expression, state)

    {key_identifier, value_identifer} =
      case vars do
        {{:var, value}, {:var, :unused}} -> {:usused, value}
        {{:var, key}, {:var, value}} -> {key, value}
      end

    normalized_source =
      cond do
        is_map(source) ->
          source

        is_array(source) ->
          source |> :array.to_list() |> Enum.with_index() |> Enum.map(fn {val, i} -> {i, val} end)
      end

    {state, results} =
      Enum.reduce(normalized_source, {state, []}, fn {key, val}, {state, results} ->
        state =
          update_in(
            state.vars,
            &Map.merge(&1, %{key_identifier => key, value_identifer => val})
          )

        {:ok, state, result} = evalutate_expressions(loop_expressions, state)
        {state, [{key, result} | results]}
      end)

    cond do
      is_map(source) ->
        {:ok, state, Map.new(results)}

      is_array(source) ->
        {:ok, state,
         Enum.map(results, fn {_i, val} -> val end) |> Enum.reverse() |> array_from_list}
    end
  end

  def evalutate_expression({adjust, {:var, variable} = expression}, state)
      when adjust in [:increment, :decrement] do
    {:ok, state, value} = evalutate_expression(expression, state)

    new_value =
      case adjust do
        :increment -> value + 1
        :decrement -> value - 1
      end

    {:ok, put_in(state.vars[variable], new_value), new_value}
  end

  def evalutate_expression({:map, key_pairs}, state) do
    map =
      key_pairs
      |> Map.new(fn {key_expression, val_expression} ->
        {:ok, _state, key} = evalutate_expression(key_expression, state)
        {:ok, _state, val} = evalutate_expression(val_expression, state)
        {key, val}
      end)

    {:ok, state, map}
  end

  def evalutate_expression({:index, expression, index_expression}, state) do
    {:ok, state, indexable} = evalutate_expression(expression, state)
    {:ok, state, index} = evalutate_expression(index_expression, state)

    result =
      cond do
        is_map(indexable) -> indexable[index]
        is_array(indexable) -> :array.get(index, indexable)
      end

    {:ok, state, result}
  end

  def evalutate_expression({:dot, expression, identifier}, state) do
    {:ok, state, dottable} = evalutate_expression(expression, state)

    case dottable do
      map when is_map(map) -> {:ok, state, Map.fetch!(map, identifier)}
    end
  end

  def evalutate_expression({:array, expressions}, state) do
    {state, evaled} =
      Enum.reduce(expressions, {state, []}, fn expression, {state, evaled} ->
        {:ok, state, result} = evalutate_expression(expression, state)
        {state, [result | evaled]}
      end)

    array =
      evaled
      |> Enum.reverse()
      |> array_from_list

    {:ok, state, array}
  end

  def evalutate_expression({:"||=", {:var, var}, expression}, state) do
    if state.vars[var] do
      {:ok, state, state.vars[var]}
    else
      {:ok, state, value} = evalutate_expression(expression, state)
      {:ok, put_in(state.vars[var], value), value}
    end
  end

  def evalutate_expression({:not, expression}, state) do
    {:ok, state, value} = evalutate_expression(expression, state)
    {:ok, state, not value}
  end

  def evalutate_expression(number, state) when is_number(number), do: {:ok, state, number}
  def evalutate_expression(string, state) when is_binary(string), do: {:ok, state, string}
  def evalutate_expression(bool, state) when is_boolean(bool), do: {:ok, state, bool}
  def evalutate_expression(nil, state), do: {:ok, state, nil}
  def evalutate_expression(:break, state), do: {:ok, state, :break}

  defp array_from_list(list) do
    :array.from_list(list, :out_of_bounds)
  end
end
