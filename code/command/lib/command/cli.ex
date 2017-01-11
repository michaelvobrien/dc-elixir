defmodule Command.CLI do
  @program "command"

  @moduledoc """
  Example command.

  It prints a test number and an optional list of names.

      command --test NUMBER [NAMES]

  ## Options

    * `--color`    - colorize output
    * `--help, -h` - prints this menu
    * `--version`  - prints the version

  ## Examples

      command --test 1
      command --test 1 arg1 arg2
  """

  @version Mix.Project.config[:version]

  @switches [
    help: :boolean,
    version: :boolean,
    color: :boolean,
    test: :integer
  ]

  def main(argv \\ System.argv) do
    argv
    |> parse_argv
    |> inspect_parsed
    |> run
  end
  
  defp parse_argv(argv) do
    OptionParser.parse(argv,
      strict: @switches,
      aliases: [
        h: :help
      ]
    )
  end

  defp inspect_parsed(parsed) do
    IO.inspect parsed
    parsed
  end

  defp switch_to_string({name, nil}),   do: name
  defp switch_to_string({name, value}), do: name <> "=" <> value

  defp run({[], [], []}),            do: print_help([])
  defp run({[color: true], [], []}), do: print_help([color: true])

  defp run({_opts, _args, invalid}) when length(invalid) > 0 do
    [switch | _] = invalid
    IO.puts "Invalid option: " <> switch_to_string(switch)
  end

  defp run({opts, args, _invalid}) do
    if opts[:help],    do: print_help(opts)
    if opts[:version], do: print_version()

    case opts do
      [test: num] -> test(num, args)
      _           -> print_no_match()
    end
  end

  defp print_no_match() do
    IO.puts "No Match"
  end

  defp print_help(opts) do
    if opts[:color] do
      IO.ANSI.Docs.print_heading(@program, [width: 80])
      IO.ANSI.Docs.print(@moduledoc, [width: 80])
    else
      IO.puts "#{@program}\n"
      IO.puts @moduledoc
    end

    System.halt(0)
  end

  defp print_version do
    IO.puts @version
    System.halt(0)
  end

  defp test(num, args) do
    test_message = "Test: #{num}"

    message =
      case args do
        [] -> test_message
        _ ->
          names = Enum.join(args, ", ")
          test_message <> " | Names: #{names}"
      end

    IO.puts message
  end
end
