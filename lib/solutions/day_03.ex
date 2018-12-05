defmodule Advent.DayThree do
  use Advent, file: "03.txt"
  import NimbleParsec

  defparsec(
    :parse_date,
    ignore(string("#"))
    |> integer(min: 1)
    |> ignore(string(" @ "))
    |> integer(min: 1)
    |> ignore(string(","))
    |> integer(min: 1)
    |> ignore(string(": "))
    |> integer(min: 1)
    |> ignore(string("x"))
    |> integer(min: 1)
  )

  def parse_file(input) do
    input
    |> Enum.map(fn line ->
      {:ok, nums, _, _, _, _} = __MODULE__.parse_date(line)
      nums
    end)
  end
  
  @doc ~S"""
  Doctest
      iex> Advent.DayThree.part_one([
      ...> "#1 @ 1,3: 4x4",
      ...> "#2 @ 3,1: 4x4",
      ...> "#3 @ 5,5: 2x2",
      ...> ])
      4
  """
  def part_one(input) do
    parse_file(input)
    |> Enum.reduce(%{}, fn [_, x, y, width, height], cloth ->
      for rx <- x..(x + width - 1),
          ry <- y..(y + height - 1) do
        {rx, ry}
      end
      |> Enum.reduce(cloth, fn coord, cloth_acc ->
        Map.update(cloth_acc, coord, :placed, fn _ -> :overlap end)
      end)
    end)
    |> Enum.count(fn {_, v} -> v == :overlap end)
  end

  @doc ~S"""
  Doctest
      iex> Advent.DayThree.part_two([
      ...> "#1 @ 1,3: 4x4",
      ...> "#2 @ 3,1: 4x4",
      ...> "#3 @ 5,5: 2x2",
      ...> ])
      3
  """
  def part_two(input) do
    parse_file(input)
    |> Enum.reduce(%{}, fn [id, x, y, width, height], cloth ->
      for rx <- x..(x + width - 1),
          ry <- y..(y + height - 1) do
        {rx, ry}
      end
      |> Enum.reduce(cloth, fn coord, cloth_acc ->
        Map.update(cloth_acc, coord, [id], fn existing -> [id | existing] end)
      end)
    end)
    |> Enum.split_with(fn {_, list} -> length(list) == 1 end)
    |> (fn {singles, duplicates} ->
          all_values = Enum.into(singles, MapSet.new(), fn {_, [x]} -> x end)

          overlaps =
            duplicates
            |> Enum.flat_map(fn {_, v} -> v end)
            |> Enum.into(MapSet.new(), & &1)

          MapSet.difference(all_values, overlaps)
        end).()
    |> Enum.fetch!(0)
  end
end
