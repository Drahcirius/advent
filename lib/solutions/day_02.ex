defmodule Advent.DayTwo do
  use Advent, file: "02.txt"

  @doc ~S"""
  Doctest
      iex> Advent.DayTwo.part_one(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"])
      12
  """
  def part_one(input) do
    input
    |> Enum.reduce({0, 0}, fn str, {twos, threes} ->
      str_map =
        str
        |> String.graphemes()
        |> Enum.group_by(& &1)

      twos = if Enum.any?(str_map, fn {_, v} -> length(v) == 2 end), do: twos + 1, else: twos

      threes =
        if Enum.any?(str_map, fn {_, v} -> length(v) == 3 end), do: threes + 1, else: threes

      {twos, threes}
    end)
    |> Tuple.to_list()
    |> Enum.reduce(1, &Kernel.*/2)
  end

  @doc ~S"""
  Doctest
      iex> Advent.DayTwo.part_two([
      ...> "abcde",
      ...> "fghij",
      ...> "klmno",
      ...> "pqrst",
      ...> "fguij",
      ...> "axcye",
      ...> "wvxyz"])
      "fgij"
  """
  def part_two(input) do
    input
    |> Enum.reduce_while(input, fn id, [_ | rest] ->
      split_id = String.graphemes(id)

      found =
        Enum.find(rest, fn val ->
          val
          |> String.graphemes()
          |> Enum.zip(split_id)
          |> Enum.reduce(0, fn {a, b}, acc -> if a == b, do: acc, else: acc + 1 end)
          |> Kernel.==(1)
        end)

      if found do
        {:halt, {id, found}}
      else
        {:cont, rest}
      end
    end)
    |> (fn {a, b} ->
          a_split = a |> String.graphemes()
          b_split = b |> String.graphemes()

          Enum.zip(a_split, b_split)
          |> Enum.filter(fn {char1, char2} -> char1 == char2 end)
          |> Enum.map(fn {char, _} -> char end)
          |> Enum.join("")
        end).()
  end
end
