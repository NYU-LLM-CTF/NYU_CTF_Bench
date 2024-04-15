defmodule Playground.Executor do
  use GenServer

  def start_link(arg \\ nil) do
    GenServer.start_link(__MODULE__, arg, name: {:global, __MODULE__})
  end

  @impl true
  def init(arg) do
    {:ok, arg}
  end

  def eval(quoted, bindings) do
    # Sends with a timeout of 30 seconds...
    GenServer.call({:global, __MODULE__}, {:eval, quoted, bindings}, 30_000)
  end

  @impl true
  def handle_call({:eval, quoted_expression, bindings}, from, state) do
    spawn(fn ->
      {{result, bindings}, stdout} =
        try do
          capture_io(fn -> Code.eval_quoted(quoted_expression, bindings) end)
        rescue
          e -> {{nil, bindings}, Exception.format(:error, e, __STACKTRACE__)}
        end

      :ok = GenServer.reply(from, {result, bindings, stdout})
    end)

    {:noreply, state}
  end

  defp capture_io(fun) do
    # This code is borrowed from ExUnit.CaptureIO.do_with_io/3
    # anything from ExUnit doesn't work in a released build and I don't know how to make it work
    # so I just copied it here...
    # if you're smart and you know how to fix this, please tell me how :)

    original_gl = Process.group_leader()
    {:ok, capture_gl} = StringIO.open("", capture_prompt: true, encoding: :unicode)

    try do
      Process.group_leader(self(), capture_gl)
      do_capture_gl(capture_gl, fun)
    after
      Process.group_leader(self(), original_gl)
    end
  end

  defp do_capture_gl(string_io, fun) do
    try do
      fun.()
    catch
      kind, reason ->
        _ = StringIO.close(string_io)
        :erlang.raise(kind, reason, __STACKTRACE__)
    else
      result ->
        {:ok, {_input, output}} = StringIO.close(string_io)
        {result, output}
    end
  end

end
