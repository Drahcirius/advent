defmodule Advent.DayEight do
  use Advent, file: "08.txt"

  @doc ~S"""
  Doctest
      iex> Advent.DayEight.part_one(["2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"])
      138
  """
  def part_one(input) do
    input
    |> List.first
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> parse_nodes
    |> elem(1)
  end

  def parse_nodes([child_number, metadata_number | rest]) do
    if child_number == 0 do
      {metadata, nodes} = Enum.split(rest, metadata_number)
      {nodes, Enum.sum(metadata)}
    else
      {nodes, value} = Enum.reduce(1..child_number, {rest, 0}, fn _, {nodes, acc} ->
        {nodes, value} = parse_nodes(nodes)
        {nodes, acc + value}
      end)
      {metadata, nodes} = Enum.split(nodes, metadata_number)
      {nodes, Enum.sum(metadata) + value}
    end
  end

  @doc ~S"""
  Doctest
      iex> Advent.DayEight.part_two(["2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"])
      66
  """
  def part_two(input) do
    input
    |> List.first
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> parse_nodes_b
    |> elem(1)
  end

  defp parse_nodes_b([child_number, metadata_number | rest]) do
    if child_number == 0 do
      {metadata, nodes} = Enum.split(rest, metadata_number)
      {nodes, Enum.sum(metadata)}
    else
      {nodes, values} = Enum.reduce(1..child_number, {rest, []}, fn _, {nodes, values} ->
        {nodes, value} = parse_nodes_b(nodes)
        {nodes, [value | values]}
      end)
      values = Enum.reverse(values)

      {metadata, nodes} = Enum.split(nodes, metadata_number)
      value = Enum.reduce(metadata, 0, fn index, acc ->
        acc + Enum.at(values, index - 1, 0)
      end)

      {nodes, value}
    end
  end
end
