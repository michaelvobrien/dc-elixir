# Command

## Basic

```elixir
# ./lib/command/cli.ex

defmodule Command.CLI do
  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parsed = OptionParser.parse(argv,
      strict: [
        help: :boolean
      ],
      aliases: [
        h: :help
      ]
    )

    case parsed do
      {[help: true], _, _} -> :help
      _                    -> :help
    end
  end

  def process(:help) do
    IO.puts "Help"
  end
end
```


## Console

```text
iex -S mix
```

## Run Using "mix"

```text
mix run -e 'Command.CLI.main(["arg1", "arg2"])'
```

## Build Escript

```text
diff --git a/mix.exs b/mix.exs
index 3ec2eef..7baa209 100644
--- a/mix.exs
+++ b/mix.exs
@@ -3,6 +3,7 @@ defmodule Command.Mixfile do

   def project do
     [app: :command,
+     escript: escript_config,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
@@ -10,6 +11,10 @@ defmodule Command.Mixfile do
      deps: deps()]
   end

+  def escript_config do
+    [ main_module: Command.CLI ]
+  end
+
   # Configuration for the OTP application
   #
   # Type "mix help compile.app" for more information
```

```text
mix deps.get
mix escript.build
```
