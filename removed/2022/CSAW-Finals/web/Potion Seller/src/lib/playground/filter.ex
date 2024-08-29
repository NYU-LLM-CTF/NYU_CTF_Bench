defmodule Playground.Filter do

  @spec filter(any) :: boolean
  def filter(expression) when is_atom(expression) do
    :ok
  end

  def filter(expression) when is_number(expression) do
    :ok
  end

  def filter(expression) when is_list(expression) do
    errors =
      expression
      |> Enum.map(&filter/1)
      |> Enum.filter(&(&1 != :ok))
      |> Enum.map(fn {:error, message} -> message end)

    if length(errors) > 0 do
      {:error, Enum.join(errors, "\n")}
    else
      :ok
    end

  end

  def filter(expression) when is_binary(expression) do
    :ok
  end

  def filter({x1, x2}) do
    filter([x1, x2])
  end

  def filter({_, _, nil}) do
    :ok
  end

  @allowed_functions [
    # Arithmetic operators
    :+,
    :-,
    :*,
    :/,
    # Assignment!
    :=,
    # Comparison operators
    :==,
    :!=,
    :===,
    :!==,
    :>,
    :>=,
    :<,
    :<=,
    :and,
    :or,
    :not,
    :&&,
    :||,
    :!,
    :in,
    # Misc built-in functions
    :abs,
    :binary_part,
    :binary_slice,
    :binding,
    :bit_size,
    :byte_size,
    :ceil,
    :div,
    :elem,
    :floor,
    :hd,
    :length,
    :map_size,
    :node,
    :rem,
    :round,
    :tl,
    :trunc,
    :tuple_size,
    :to_string,
    :to_charlist,
    :<>,
    # Data types
    :%{},
    :{},
    :<<>>,
    :..,
    :if,
    :unless,
    :min,
    :max,
    :inspect,
    :pop_in,
    :put_elem,
    :put_in,
    :get_and_update_in,
    :get_in,
    # Sigils (e.g. ~r/regex/)
    :sigil_C,
    :sigil_c,
    :sigil_D,
    :sigil_N,
    :sigil_R,
    :sigil_r,
    :sigil_S,
    :sigil_s,
    :sigil_W,
    :sigil_w,
    :sigil_T,
    :sigil_U,
    # Function basics
    :fn,
    :->,
    # Message passing and process control
    :spawn,
    :send,
    :receive,
    :self,
    # Other built-ins
    :__block__,
    :__aliases__,
    # Guards
    :when,
    :is_atom,
    :is_binary,
    :is_bitstring,
    :is_boolean,
    :is_exception,
    :is_float,
    :is_function,
    :is_integer,
    :is_list,
    :is_map,
    :is_map_key,
    :is_nil,
    :is_number,
    :is_pid,
    :is_port,
    :is_reference,
    :is_struct,
    :is_tuple,
    # Other nice operators
    :|>, # Praise be to the pipe operator
    :++,
    :--,
    # Meta-programming?
    :quote
  ]

  def filter({operator, _, args}) when is_atom(operator) and operator in @allowed_functions do
    filter(args)
    #Enum.all?(args, &filter/1)
  end

  def filter({{:., _, fun}, _, args}) do
    call_test = filter_function(fun, args)

    if call_test == :ok do
      filter(args)
    else
      call_test
    end
  end

  def filter(expression) do
    {:error, "Disallowed expression: #{inspect(expression)}"}
  end


  @allowed_modules [
    Process,
    Enum,
    Date,
    DateTime,
    Float,
    Integer,
    NaiveDateTime,
    Regex,
    String,
    Tuple,
    URI,
    Access,
    Date.Range,
    Keyword,
    List,
    Map,
    MapSet,
    Range,
    Base,
    GenServer
  ]

  defp filter_function([{:__aliases__, context, module}, function], args) do
    if filter(module) do
      {module, _} = Code.eval_quoted({:__aliases__, context, module})
      filter_function([module, function], args)
    else
      {:error, "Disallowed module: #{inspect(module)}"}
    end
  end

  defp filter_function([module, _], _args) when module in @allowed_modules do
    :ok
  end

  @allowed_functions %{
    IO => [inspect: 1, puts: 1],
    :erlang => [term_to_binary: 1, binary_to_term: 1],
    Code => [string_to_quoted: 1],
    Kernel => [to_string: 1]
  }

  defp filter_function([module, function], args) do
    arity = length(args)
    allowed = Map.get(@allowed_functions, module, [])

    if Keyword.has_key?(allowed, function) and Keyword.get(allowed, function) == arity do
      :ok
    else
      {:error, "Disallowed function: #{inspect(module)}.#{inspect(function)}/#{arity}"}
    end
  end

  defp filter_function(_, _) do
    {:error, "Unhandled function call type"}
  end
end
