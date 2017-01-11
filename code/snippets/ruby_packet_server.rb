#!/usr/bin/env ruby
# http://theerlangelist.com/article/outside_elixir

STDOUT.sync = true

def receive_input
  encoded_length = STDIN.read(4)
  return nil unless encoded_length

  length = encoded_length.unpack("N").first
  STDIN.read(length)
end

def send_response(value)
  response = value.inspect
  STDOUT.write([response.bytesize].pack("N"))
  STDOUT.write(response)
  true
end

context = binding
while (cmd = receive_input) do
  eval(cmd, context)
end
