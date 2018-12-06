defmodule Advent.DaySix do
  use Advent, file: "06.txt"
  import NimbleParsec

  defparsec(
    :parse_coordinate,
    integer(min: 1)
    |> ignore(string(", "))
    |> integer(min: 1)
  )

  @doc ~S"""
  Doctest
      iex> Advent.DaySix.part_one([
      ...> "1, 1",
      ...> "1, 6",
      ...> "8, 3",
      ...> "3, 4",
      ...> "5, 5",
      ...> "8, 9"
      ...> ])
      17
  """
  def part_one(input) do
    {coords, lowx, highx, lowy, highy} = get_points_and_ranges(input)

    graph =
      for x <- lowx..highx,
          y <- lowy..highy do
        {x, y}
      end
      |> Enum.into(%{}, fn point ->
        result =
          coords
          |> Enum.reduce({nil, :infinity}, fn destination, {_, curr_value} = curr ->
            distance = manhattan_distance(point, destination)

            case distance do
              0 -> {destination, 0}
              x when x == curr_value -> {nil, x}
              x when x < curr_value -> {destination, x}
              x when x > curr_value -> curr
            end
          end)
          |> elem(0)

        {point, result}
      end)

    x_edges =
      for x <- lowx..highx,
          y <- [lowy, highy] do
        {x, y}
      end

    y_edges =
      for x <- [lowx, highx],
          y <- lowy..highy do
        {x, y}
      end

    edges = x_edges ++ y_edges

    infinites = Enum.reduce(edges, MapSet.new(), fn x, acc -> MapSet.put(acc, graph[x]) end)

    graph
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.into(%{}, fn {k, v} -> {k, length(v)} end)
    |> Enum.max_by(fn {x, len} ->
      if MapSet.member?(infinites, x) or x == nil, do: 0, else: len
    end)
    |> elem(1)
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  @doc ~S"""
  Doctest
      iex> Advent.DaySix.part_two([
      ...> "1, 1",
      ...> "1, 6",
      ...> "8, 3",
      ...> "3, 4",
      ...> "5, 5",
      ...> "8, 9"
      ...> ], 32)
      16
  """
  def part_two(input, within \\ 10000) do
    {coords, lowx, highx, lowy, highy} = get_points_and_ranges(input)

    for x <- lowx..highx,
        y <- lowy..highy do
      {x, y}
    end
    |> Enum.reduce(0, fn point, acc ->
      total_distance =
        Enum.reduce(coords, 0, fn coordinate, distance ->
          distance + manhattan_distance(point, coordinate)
        end)

      if total_distance < within do
        acc + 1
      else
        acc
      end
    end)
  end

  def get_points_and_ranges(input) do
    coords =
      Enum.map(input, fn line ->
        {:ok, [x, y], _, _, _, _} = __MODULE__.parse_coordinate(line)
        {x, y}
      end)

    {lowx, highx} =
      coords
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {lowy, highy} =
      coords
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    {coords, lowx, highx, lowy, highy}
  end
end
