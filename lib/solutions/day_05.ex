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
    |> parse_polymer()
    |> length
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

    Task.async_stream(?A..?Z, fn bin ->
      casebin = bin ^^^ 32

      polymer
      |> Enum.filter(&(&1 != bin && &1 != casebin))
      |> parse_polymer([], 0)
      |> length
    end)
    |> Enum.min_by(fn {:ok, len} -> len end)
    |> elem(1)
  end

  defp parse_polymer(polymer) do
    polymer
    |> String.graphemes()
    |> Enum.map(fn <<x::integer>> -> x end)
    |> parse_polymer([], 0)
  end

  defp parse_polymer([a], acc, 0) do
    [a | acc]
  end

  defp parse_polymer([], acc, _) do
    parse_polymer(acc, [], 0)
  end

  defp parse_polymer([a], acc, _) do
    parse_polymer([a | acc], [], 0)
  end

  defp parse_polymer([a, b | t], acc, remove_count) do
    if a == b ^^^ 32 do
      parse_polymer(t, acc, remove_count + 1)
    else
      parse_polymer([b | t], [a | acc], remove_count)
    end
  end
end
