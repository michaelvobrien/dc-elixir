autoscale: true

# |> Elixir.Scripting

## Michael V. O'Brien

## @michaelvobrien

## github.com/michaelvobrien/dc-elixir

--------------------------------------------------------------

# 🤔

--------------------------------------------------------------

# ruby -e

```sh
$ ls | ruby -pe '$_.upcase!'
README.MD
_BUILD/
COMMAND
CONFIG/
LIB/
MIX.EXS
TEST/
```

--------------------------------------------------------------

# ~/bin/

` `

--------------------------------------------------------------

# ~/bin/

```sh
$ ls ~/bin/ | wc -l
     164
```

--------------------------------------------------------------

# \`cmd\`

```ruby
irb> `date`
=> "Mon Jan  9 21:58:27 EST 2017\n"
```

--------------------------------------------------------------

# system()

```ruby
irb> system("date")
Mon Jan  9 21:57:15 EST 2017
=> true
```

--------------------------------------------------------------

# popen3()

```ruby
irb> stdin = "hiya\n"
irb> stdout, stderr, status =
       Open3.capture3("cat", :stdin_data => stdin)

=> ["hiya\n", "", #<Process::Status: pid 39408 exit 0>]
```

--------------------------------------------------------------

# Programs

* Command-Line Applications (CLI Apps)
* Using `escript`

--------------------------------------------------------------

# Not Covering

* Testing
    - `ExUnit.CaptureIO`
* NIF - function implemented in C instead of Elixir
* Porcelain

--------------------------------------------------------------

## `¯\_(ツ)_/¯`

--------------------------------------------------------------

>Make each program do one thing well.
-- Douglas McIlroy, the inventor of Unix pipes

--------------------------------------------------------------

>Expect the output of every program to become the input to another, as yet unknown, program. Don't clutter output with extraneous information.
-- Douglas McIlroy, the inventor of Unix pipes

--------------------------------------------------------------

# One Way To Think About It

`SOME_PROGRAM | your-awesome-program | grep | awk`

--------------------------------------------------------------

# elixir -e 'COMMAND'

^ C-d to send SIGQUIT signal

--------------------------------------------------------------

# elixir -e

* upcase results of "ls"

--------------------------------------------------------------

```sh
ls | elixir -e '
IO.stream(:stdio, :line)
|> Enum.each(&(String.upcase(&1) |> IO.write))
'
```

--------------------------------------------------------------

# elixir-pe

* `"while gets"` and `"print"` on each line

--------------------------------------------------------------

```elixir
defmodule Command do
  def run(commands) do
    code = """
    IO.stream(:stdio, :line)
    |> Enum.each(fn(line) ->
      chomp(line)
      |> #{commands}
      |> IO.puts
    end)
    """
    Code.eval_string(code, [commands: commands], __ENV__)
  end
end

[command | _rest] = System.argv
Command.run(command)
```

--------------------------------------------------------------

```elixir
defmodule Helpers do
  def chomp(string) do
    String.trim_trailing(string, "\n")
  end

  def p(arg) do
    inspect(arg, pretty: true)
  end
end
```

--------------------------------------------------------------

```elixir
defmodule Command do
  import Helpers, warn: false
  import IO,      warn: false, except: [inspect: 1, inspect: 2]
  import String,  warn: false, except: [reverse: 1]
  import Enum,    warn: false, except: [
    at: 2,
    chunk: 2,
    slice: 2,
    slice: 3,
    split: 2
  ]
end
```


--------------------------------------------------------------

# elixir-pe

* upcase results of "ls"

--------------------------------------------------------------

```sh
$ ls | elixir-pe 'upcase'
README.MD
_BUILD/
CHANGEE
CONFIG/
LIB/
MIX.EXS
TEST/
```

--------------------------------------------------------------

```sh
$ ls | elixir-pe 'upcase |> split("") |> reverse'
DM.EMDAER
/DLIUB_
EEGNAHC
/GIFNOC
/BIL
SXE.XIM
/TSET
```

--------------------------------------------------------------

# elixir-n

* `"while gets"`

--------------------------------------------------------------

```elixir
defmodule Command
  def run(commands) do
    code = """
    IO.stream(:stdio, :line)
    |> #{commands}
    """
    Code.eval_string(code, [commands: commands], __ENV__)
  end
end
```

--------------------------------------------------------------

# elixir-n

* print out file with line numbers

--------------------------------------------------------------

```sh
cat elixir-n | elixir-n '
reduce(1, fn(l, acc) ->
  lineno = acc |> to_string |> rjust(2)
  write("#{lineno} #{l}")
  acc + 1
end)'
```

--------------------------------------------------------------

```sh
cat elixir-n | elixir-n '
reduce(1, fn(l, acc) ->
  lineno = acc |> to_string |> rjust(2)
  write("#{lineno} #{l}")
  acc + 1
end)'
```

```markdown
 1 #!/usr/bin/env elixir
 2 # similar to `while gets`
 3
 4 defmodule Helpers do
 5   def chomp(string) do
 6     String.trim_trailing(string, "\n")
 7   end
 8
 9   def p(arg) do
10     inspect(arg, pretty: true)
```

--------------------------------------------------------------

# ~/bin/ and .exs

--------------------------------------------------------------

# print-hiya.exs

```elixir
#!/usr/bin/env elixir

IO.puts "hiya"
```

--------------------------------------------------------------

# [FIT] "mix run" for scripts with deps

^ [{:porcelain, "~> 2.0"}]

--------------------------------------------------------------

```sh
$ mix new scripts
$ cd scripts
$ mkdir scripts
$ edit mix.exs
$ edit scripts/date.exs
$ mix deps.get
$ mix run scripts/date.exs
```

--------------------------------------------------------------

```diff
  defp deps do
+   [{:porcelain, "~> 2.0"}]
  end
```

--------------------------------------------------------------

# "escript" for programs

^ mix run -e 'Changee.CLI.main([])'
^ [main_module: Changee.CLI]

--------------------------------------------------------------

```sh
$ mix new changee
$ cd changee
$ mkdir lib/changee
$ edit lib/changee/cli.ex
$ edit mix.exs
$ mix escript.build
$ ./changee test args
```

--------------------------------------------------------------

```diff
  .
  ├── README.md
  ├── config
  │   └── config.exs
  ├── lib
+ │   ├── changee
+ │   │   └── cli.ex
  │   └── changee.ex
  ├── mix.exs
  └── test
      ├── changee_test.exs
      └── test_helper.exs
```

--------------------------------------------------------------

```elixir
defmodule Changee.CLI do
  def main(argv) do
    IO.inspect argv
  end
end
```

--------------------------------------------------------------

```diff
   def project do
     [app: :changee,
+     escript: escript_build(),
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      deps: deps()]
   end

+  defp escript_build do
+    [main_module: Changee.CLI]
+  end
```

--------------------------------------------------------------

# OptionParser

--------------------------------------------------------------

# OptionParser

```elixir
{[opts], [args], [invalid]}
```

--------------------------------------------------------------

# OptionParser: opts


```elixir
iex> OptionParser.parse(["--help"], switches: [help: :boolean])
{[help: true], [], []}
```

--------------------------------------------------------------

# OptionParser: args

```elixir
iex> OptionParser.parse(["arg1"])
{[], ["arg1"], []}
```

--------------------------------------------------------------

# OptionParser: invalid

`switches vs. strict`

```elixir
iex> OptionParser.parse(["--foo", "bar"], switches: [test: :integer])
{[], [], [{"--foo", "bar"}]}
iex> OptionParser.parse(["--foo", "bar"], strict: [test: :integer])
{[], ["bar"], [{"--foo", nil}]}
```

--------------------------------------------------------------

# OptionParser: @switches

```elixir
defmodule Command.CLI do
  @switches [
    help: :boolean,
    version: :boolean
  ]
  
  def parse_args(argv) do
    OptionParser.parse(argv, switches: @switches)
  end
end
```

--------------------------------------------------------------

# OptionParser: help, @moduledoc

```elixir
defmodule Command.CLI do
  @moduledoc """
  command

  Example command.

  It prints a test number and an optional list of names.

      command --test NUMBER [NAMES]

  ## Options

    * `--help, -h` - prints this menu
    * `--version`  - prints the version

  ## Examples

      command --test 1
  """

  defp print_help do
    IO.puts @moduledoc
    System.halt(0)
  end
end
```

--------------------------------------------------------------

# OptionParser: version, @version

```elixir
defmodule Command.Mixfile do
  use Mix.Project

  def project do
    [app: :command,
     escript: escript_config(),
     version: "0.1.0",
     deps: deps()]
  end
end

defmodule Command.CLI do
  @version Mix.Project.config[:version]

  defp print_version do
    IO.puts @version
    System.halt(0)
  end
end
```

--------------------------------------------------------------

# Executing External Programs

* `:os.cmd/1`
* `System.cmd/3`
* `Port`

--------------------------------------------------------------

# :os.cmd/1

```markdown
:os.cmd(command)
:os.cmd(charlist) :: charlist
```

Executes the `command` in a command shell. Returns the captured output as a `charlist`.

--------------------------------------------------------------

# Use Case In The Wild

```elixir
defmodule System do
  defmacrop get_revision do
    null = '/dev/null'

    'git rev-parse --short HEAD 2> '
    |> Kernel.++(null)
    |> :os.cmd()
    |> strip
  end
end
```

--------------------------------------------------------------

# Pros

* `STDOUT`
* command charlist is executed as is
* able to pipe within the charlist

--------------------------------------------------------------

# Cons

* no exit status
* no `STDIN`, `STDOUT`, `STDERR` streams

--------------------------------------------------------------

# System.cmd/3

Similiar to `system()`

--------------------------------------------------------------


# System.cmd/3

```markdown
cmd(command, args, opts \\ [])
cmd(binary, [binary], Keyword.t) :: {Collectable.t, exit_status}
```

Executes the `command` with `args`. Returns captured output as a `Collectable` and returns the `exit_status`.

--------------------------------------------------------------

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

--------------------------------------------------------------

# Options

* `:cd` - the directory to run the command in
* `:env` - key-value list, e.g. `[PROJ_ENV: "dev"]`
* `:stderr_to_stdout` - redirects `STDERR` to `STDOUT`

--------------------------------------------------------------

# Pros

* exit status
* `STDOUT` stream
* redirect `STDERR` to `STDOUT`

--------------------------------------------------------------

# Cons

* no `STDIN` stream
* no standalone `STDERR` stream
* cannot kill external program

--------------------------------------------------------------

# Good To Know

`System.cmd/3` uses `Port` for its implementation.

--------------------------------------------------------------

# Port.open/2

Similar to `popen()`

--------------------------------------------------------------

# Port.open/2

```markdown
open(name, settings)
open(name, list) :: port
```

For `name`, pass `{:spawn, command}` to run an external program. Opens a port to send/receive messages with the `command`.

--------------------------------------------------------------

# Implemented Using

`:erlang.open_port/2`

--------------------------------------------------------------

# Example

```elixir
iex> cmd = "echo hiya"
iex> port = Port.open({:spawn, cmd}, [:binary, :exit_status])
iex> flush()
{#Port<0.4581>, {:data, "hiya\n"}}
{#Port<0.4581>, {:exit_status, 0}}
```

--------------------------------------------------------------

```elixir
defmodule System
  def cmd(command, args, given_opts \\ []) do
    default_opts = [:use_stdio, :exit_status, :binary, :hide, args: args]

    {into, opts} = merge(given_opts, default_opts)
  
    {initial, fun} = Collectable.into(into || "")
    do_cmd(Port.open({:spawn_executable, command}, opts), initial, fun)
  end

  defp do_cmd(port, acc, fun) do
    receive do
      {^port, {:data, data}} ->
        do_cmd(port, fun.(acc, {:cont, data}), fun)
      {^port, {:exit_status, status}} ->
        {acc, status}
    end
  end
end
```

--------------------------------------------------------------

## File.Stream

```sh
iex> stream = File.stream!("afile")

$ lsof | grep afile
# => nothing, closed

iex> {:ok, fun} = Collectable.into stream
{:ok, #Function<1.6439872/2 in Collectable.File.Stream.into/3>}

$ lsof | grep afile
# => open, 0 bytes

iex> :ok = fun.(:ok, {:cont, "hiya\n" })

$ lsof | grep afile
# => open, 5 bytes

iex> stream = fun.(:ok, :done)

$ lsof | grep afile
# => nothing, closed
# => 5 bytes
```

--------------------------------------------------------------

# Port.close/1

```markdown
close(port)
close(port) :: true
```

Closes the `port` and closes the file descriptors to the external program.

--------------------------------------------------------------

# Implemented Using

`:erlang.port_close/1`

--------------------------------------------------------------

# Example

```elixir
iex> cmd = "cat"
iex> port = Port.open({:spawn, cmd}, [:binary])
iex> Port.close(port)
true
```

--------------------------------------------------------------

# "send" Equivalent

```elixir
iex> cmd = "cat"
iex> port = Port.open({:spawn, cmd}, [:binary])
iex> send port, {self(), :close}
:ok
iex> flush()
{#Port<0.1464>, :closed}
```

--------------------------------------------------------------

# Port.command/3

```markdown
command(port, data, options \\ [])
command(port, iodata, [:force | :nosuspend]) :: boolean
```

Sends `data` to the port driver `port`.

--------------------------------------------------------------

# Implemented Using

`:erlang.port_command/3`

--------------------------------------------------------------

# Example

```elixir
iex> cmd = "cat"
iex> port = Port.open({:spawn, cmd}, [:binary])
iex> Port.command(port, "hello")
iex> Port.command(port, "world")
iex> flush()
{#Port<0.1444>, {:data, "hello"}}
{#Port<0.1444>, {:data, "world"}}
```

--------------------------------------------------------------

# "send" Equivalent

```elixir
iex> cmd = "cat"
iex> port = Port.open({:spawn, cmd}, [:binary])
iex> send port, {self(), {:command, "hello"}}
iex> send port, {self(), {:command, "world"}}
iex> flush()
{#Port<0.1444>, {:data, "hello"}}
{#Port<0.1444>, {:data, "world"}}
```

--------------------------------------------------------------

# Pros

* exit status
* `STDIN` stream
* `STDOUT` stream
* combined `STDOUT` and `STDERR` stream

--------------------------------------------------------------

# Cons

* no standalone `STDERR` stream
* cannot kill external program

--------------------------------------------------------------

# One More Thing

--------------------------------------------------------------

# Packing Messages

--------------------------------------------------------------

# References 🤓📚

* <http://theerlangelist.com/article/outside_elixir>
* <https://github.com/alco/porcelain>
* <https://github.com/alco/goon>
* <http://erlang.org/pipermail/erlang-questions/2013-July/074905.html>
* <http://erlang.org/pipermail/erlang-questions/2010-March/050232.html>
* <https://github.com/elixir-lang/elixir/issues/3425>
* <http://www.linuxjournal.com/content/determine-if-shell-input-coming-terminal-or-pipe>
* <https://groups.google.com/forum/#!msg/elixir-lang-talk/djwL8I-FJYU/rXogRaBAEgAJ>
* <http://ferd.ca/repl-a-bit-more-and-less-than-that.html>
* <https://hexdocs.pm/elixir/Port.html#module-zombie-processes>
* <http://www.faqs.org/docs/artu/ch01s06.html>
* <http://shellhaters.org>
* <http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html>
* <http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_09_01>
* <http://www.multicians.org/shell.html>
* <https://www.amazon.com/Power-Tools-Third-Shelley-Powers/dp/0596003307>
* <https://www.amazon.com/Advanced-Programming-UNIX-Environment-3rd/dp/0321637739>
* <https://www.amazon.com/Build-Awesome-Command-Line-Applications-Ruby/dp/1937785750>
