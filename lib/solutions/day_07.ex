defmodule Advent.DaySeven do
  use Advent, file: "07.txt"

  @doc ~S"""
  Doctest
      iex> Advent.DaySeven.part_one([
      ...> "Step C must be finished before step A can begin.",
      ...> "Step C must be finished before step F can begin.",
      ...> "Step A must be finished before step B can begin.",
      ...> "Step A must be finished before step D can begin.",
      ...> "Step B must be finished before step E can begin.",
      ...> "Step D must be finished before step E can begin.",
      ...> "Step F must be finished before step E can begin.",
      ...> ])
      "CABDFE"
  """
  def part_one(input) do
    edge_map = generate_edge_map(input)

    Stream.unfold({edge_map, ""}, fn
      {edge_map, output} = curr when map_size(edge_map) == 0 ->
        {curr, {%{}, output}}

      {edge_map, output} = curr ->
        {head, _} =
          edge_map
          |> Enum.min_by(fn {<<k::integer>>, v} -> length(v) * 100 + k end)

        output = output <> head

        edge_map = Map.delete(edge_map, head)

        edge_map =
          edge_map
          |> Enum.into(%{}, fn {k, paths} ->
            paths = Enum.filter(paths, fn node -> node != head end)
            {k, paths}
          end)

        {curr, {edge_map, output}}
    end)
    |> Enum.find(fn {nodes, _} -> map_size(nodes) == 0 end)
    |> elem(1)
  end

  def generate_edge_map(input) do
    input
    |> Enum.reduce(%{}, fn line, edge_map ->
      step = binary_part(line, 5, 1)
      requirement = binary_part(line, 36, 1)

      edge_map = Map.update(edge_map, requirement, [step], fn r -> [step | r] end)
      edge_map = Map.update(edge_map, step, [], & &1)
    end)
  end

  @doc ~S"""
  Doctest
  """
  def part_two(input, delay \\ 0) do
  end
end
