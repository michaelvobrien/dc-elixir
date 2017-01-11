elixir-n '
reduce(1, fn(l, acc) ->
  lineno = acc |> to_string |> rjust(2)
  write("#{lineno} #{l}")
  acc + 1
end)'
