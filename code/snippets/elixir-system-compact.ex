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
