#!/usr/bin/env elixir
# http://theerlangelist.com/article/outside_elixir

cmd = "./ruby_packet_server.rb"

port = Port.open({:spawn, cmd}, [:binary, {:packet, 4}])

Port.command(port, "a = 1")
Port.command(port, ~S"""
  while a < 10 do
    a *= 3
  end
""")

Port.command(port, ~S"""
  send_response(a)
""")

receive do
  {^port, {:data, result}} ->
    IO.puts("Elixir got: #{inspect result}")
end

Port.close(port)
