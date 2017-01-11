#!/usr/bin/env elixir

defmodule IOLists do
  def clear_screen do
    [
      IO.ANSI.home,
      IO.ANSI.clear
    ]
  end

  def intentionally_left_blank_message do
    [
      "\n\n",
      IO.ANSI.bright,
      "    [intentionally left blank]\n",
      IO.ANSI.reset,
      "\n\n"
    ]
  end

  def out do
    IO.write [
      clear_screen,
      intentionally_left_blank_message
    ]
  end
end

IOLists.out()
