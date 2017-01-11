# Example

```elixir
iex> {out, exit_status} = System.cmd("ls", [])
iex> out
"README.md\n_build\nafile\ncommand\nconfig\nlib\nmix.exs\ntest\n"
iex> exit_status
0
```

--------------------------------------------------------------

# Example (1/5)

```elixir
iex> {out, exit_status} = System.cmd("ls", [], into: "")
{"README.md\n_build\ncommand\nconfig\nlib\nmix.exs\ntest\n", 0}
```

^ `into` needs to implement the `Collectable` protocol.

--------------------------------------------------------------

# Example (2/5)

```elixir
iex> {out, exit_status} = System.cmd("ls", [], into: "OUTPUT: ")
{"OUTPUT: README.md\n_build\ncommand\nconfig\nlib\nmix.exs\ntest\n", 0}
```
--------------------------------------------------------------

# Example (3/5)

```elixir
iex> stream = IO.stream(:stdio, :line)
%IO.Stream{device: :standard_io, line_or_bytes: :line, raw: false}
iex> IO.write(stream.device, "hiya\n")
hiya
```

--------------------------------------------------------------

# Example (4/5)

```elixir
iex> stream = IO.stream(:stdio, :line)
iex> {out, exit_status} = System.cmd("ls", [], into: stream)
README.md
_build
command
config
lib
mix.exs
test
```

--------------------------------------------------------------

# Example (5/5)

```elixir
iex> stream = File.stream!("afile")
iex> {out, exit_status} = System.cmd("ls", [], into: stream)
iex> File.read!(stream.path)
"README.md\n_build\nafile\ncommand\nconfig\nlib\nmix.exs\ntest\n"
iex> File.read!(out.path)
"README.md\n_build\nafile\ncommand\nconfig\nlib\nmix.exs\ntest\n"
iex> stream == out
true
```
