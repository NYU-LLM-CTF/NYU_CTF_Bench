defmodule PlaygroundWeb.SessionLive.Index do
  use PlaygroundWeb, :live_view

  @default_results %{
    stdout:
      "This is where anything printed to stdout (e.g. from a call to IO.puts or IO.inspect) will appear.",
    data:
      "The result of evaluating your code; this will be the value of the final expression in your code."
  }

  @default_code """
  # Welcome to Elixir! Let's get started with some basics.

  # Variables work like you'd expect:
  x = 1
  y = 2

  # We have most of the usual variable types:
  z = 3.0 # Float
  a = true # Boolean
  b = "Hello, world!" # String / binary (in double quotes)
  c = :atom # Atom
  d = [1, 2, 3] # List
  e = 'Hello, world!' # Charlist (in single quotes) - actually just a list of integers
  f = {1, 2, 3} # Tuple
  g = %{a: 1, b: 2, c: 3} # Map

  # Note that the "=" operator is a pattern matching operator, not an assignment operator.
  # This lets you do fancier things like this:
  {a, b} = {1, 2}
  [a, b] = [1, 2]
  %{a: a, b: b} = %{a: 1, b: 2}

  # Most of the usual math operators work as you'd expect.

  # The unique thing about Elixir and the Erlang VM is process-based concurrency.
  # We can spawn many new processes that can run concurrently.

  spawn(fn -> 1 + 2 end)

  # To communicate values between processes, we have to send messages.
  # Each process has a "mailbox" where messages are stored.
  # We can send messages to a process using the send function, and receive messages using the receive function.
  # Each process has a PID (process ID) that we can use to send messages to it.
  # We can get the PID of the current process using self().
  # Let's put this all together to spawn a new process that sends us a message:
  owner = self()
  spawn(fn -> send(owner, {self(), :hello}) end)
  receive do
    {pid, message} -> IO.puts "Received " <> inspect(message) <> " from " <> inspect(pid)
  end

  # Traditional Elixir/Erlang code uses processes that process incoming messages recursively, like a server.
  """

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket |> assign(:bindings, []) |> assign(:results, @default_results) |> assign(:error, nil) |> assign(:default_code, @default_code)

    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Session")}
  end

  @impl true
  def handle_event("eval", %{"input" => %{"code" => code}}, socket) do
    # This function handle clicking the "Evaluate" button.

    try do
      # Double-check the AST for safety.
      quoted = Code.string_to_quoted!(code)
      allowed = Playground.Filter.filter(quoted)

      socket = if allowed == :ok do
        # All good, send the code to the evaluation server.
        Task.Supervisor.async_nolink(Playground.TaskSupervisor, fn ->
          Playground.Executor.eval(quoted, socket.assigns.bindings)
        end)

        socket |> assign(:results, %{stdout: "Evaluating...", data: "Evaluating..."}) |> assign(:error, nil)
      else
        {:error, messages} = allowed

        socket |> assign(:error, "Safety filter rejected your code:\n\n#{messages}")
      end

      {:noreply, socket}
    rescue
      # Syntax errors are caught here...
      e ->
        {:noreply,
         socket
         |> assign(:results, @default_results) |> assign(:error, "Error parsing your code:\n\n#{Exception.format(:error, e, __STACKTRACE__)}")}
    end
  end

  def handle_event("delete", %{"key" => key}, socket) do
    # Variable deletion (via the "x" button next to the variable name)
    real_key = String.to_existing_atom(key)

    updated_bindings = socket.assigns.bindings |> Keyword.delete(real_key)

    {:noreply, socket |> assign(:bindings, updated_bindings)}
  end

  @impl true
  def handle_info({ref, {result, bindings, stdout}}, socket) do
    Process.demonitor(ref, [:flush])

    socket =
      socket |> assign(:results, %{stdout: stdout, data: result}) |> assign(:bindings, bindings)

    {:noreply, socket}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, socket) do
    # This will happen if the evaluation process crashes (this shouldn't happen unless something goes very wrong)
    socket = socket |> assign(:error, "An unknown error occurred during evaluation")

    {:noreply, socket}
  end

end
