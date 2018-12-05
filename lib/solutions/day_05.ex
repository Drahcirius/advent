defmodule Advent.DayFive do
  use Advent, file: "05.txt"
  use Bitwise

  @doc ~S"""
  Doctest
      iex> Advent.DayFive.part_one(["dabAcCaCBAcCcaDA"])
      10
  """
  def part_one(input) do
    input
    |> List.first()
    |> String.graphemes()
    |> Enum.map(fn <<x::integer>> -> x end)
    |> get_polymer_length([0])
  end

  @doc ~S"""
  Doctest
      iex> Advent.DayFive.part_two(["dabAcCaCBAcCcaDA"])
      4 
  """
  def part_two(input) do
    polymer =
      input
      |> List.first()
      |> String.graphemes()
      |> Enum.map(fn <<x::integer>> -> x end)

    Enum.zip(?a..?z, ?A..?Z)
    |> Task.async_stream(fn {lower, capital} ->
      polymer
      |> Enum.filter(&(&1 != lower && &1 != capital))
      |> get_polymer_length([0])
    end)
    |> Enum.min_by(fn {:ok, len} -> len end)
    |> elem(1)
  end

  defp get_polymer_length([a], acc) do
    length([a | acc]) - 1
  end

  defp get_polymer_length([a, b | t], acc) do
    if a == b ^^^ 32 do
      [c | acc] = acc
      get_polymer_length([c | t], acc)
    else
      get_polymer_length([b | t], [a | acc])
    end
  end
end
