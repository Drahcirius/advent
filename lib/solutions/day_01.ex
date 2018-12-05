defmodule Advent.DayOne do
  use Advent, file: "01.txt"

  @doc ~S"""
  Doctest
      iex> Advent.DayOne.part_one(["+1", "-2", "+3", "+1"])
      3
  """
  def part_one(input) do
    input
    |> Enum.reduce(0, fn num, acc ->
      {num, _} = Integer.parse(num)
      acc + num
    end)
  end

  @doc ~S"""
  Doctest
      iex> Advent.DayOne.part_two(["+3", "+3", "+4", "-2", "-4"])
      10
  """
  def part_two(input) do
    input
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new()}, fn num, {curr, curr_set} ->
      {num, _} = Integer.parse(num)

      if MapSet.member?(curr_set, curr) do
        {:halt, curr}
      else
        set = MapSet.put(curr_set, curr)
        curr = curr + num
        {:cont, {curr, set}}
      end
    end)
  end
end
