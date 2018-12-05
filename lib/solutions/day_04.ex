defmodule Advent.DayFour do
  use Advent, file: "04.txt"

  defp parse_file(input) do
    input
    |> Enum.map(fn line ->
      "[" <> <<date::binary-size(16)>> <> "] " <> text = line
      {date, text}
    end)
    |> Enum.sort_by(&elem(&1, 0), &</2)
    |> Enum.reduce({%{}, %{}, nil, nil}, fn {time, text},
                                            {sleep_counter, sleep_ranges, id, timestamp} ->
      case text do
        "Guard #" <> rest ->
          {id, _} = Integer.parse(rest)
          {sleep_counter, sleep_ranges, id, timestamp}

        "falls asleep" ->
          {sleep_counter, sleep_ranges, id, time}

        "wakes up" ->
          begin_time = timestamp |> binary_part(14, 2) |> String.to_integer()
          end_time = time |> binary_part(14, 2) |> String.to_integer()
          sleep_time = end_time - begin_time

          sleep_counter = Map.update(sleep_counter, id, sleep_time, &(&1 + sleep_time))
          range = begin_time..(end_time - 1)
          sleep_ranges = Map.update(sleep_ranges, id, [range], &[range | &1])
          {sleep_counter, sleep_ranges, id, time}
      end
    end)
  end

  @doc ~S"""
  Doctest
      iex> Advent.DayFour.part_one([
      ...> "[1518-11-01 00:00] Guard #10 begins shift",
      ...> "[1518-11-01 00:05] falls asleep",
      ...> "[1518-11-01 00:25] wakes up",
      ...> "[1518-11-01 00:30] falls asleep",
      ...> "[1518-11-01 00:55] wakes up",
      ...> "[1518-11-01 23:58] Guard #99 begins shift",
      ...> "[1518-11-02 00:40] falls asleep",
      ...> "[1518-11-02 00:50] wakes up",
      ...> "[1518-11-03 00:05] Guard #10 begins shift",
      ...> "[1518-11-03 00:24] falls asleep",
      ...> "[1518-11-03 00:29] wakes up",
      ...> "[1518-11-04 00:02] Guard #99 begins shift",
      ...> "[1518-11-04 00:36] falls asleep",
      ...> "[1518-11-04 00:46] wakes up",
      ...> "[1518-11-05 00:03] Guard #99 begins shift",
      ...> "[1518-11-05 00:45] falls asleep",
      ...> "[1518-11-05 00:55] wakes up",
      ...> ])
      240
  """
  def part_one(input) do
    {sleep_counter, sleep_ranges, _, _} = parse_file(input)

    {heaviest_sleeper, _} =
      sleep_counter
      |> Enum.max_by(&elem(&1, 1))

    {most_common, _} =
      sleep_ranges
      |> Map.get(heaviest_sleeper)
      |> Enum.flat_map(fn range -> for x <- range, do: x end)
      |> Enum.group_by(& &1)
      |> Enum.max_by(fn {_, items} -> length(items) end)

    heaviest_sleeper * most_common
  end

  @doc ~S"""
  Doctest
      iex> Advent.DayFour.part_two([
      ...> "[1518-11-01 00:00] Guard #10 begins shift",
      ...> "[1518-11-01 00:05] falls asleep",
      ...> "[1518-11-01 00:25] wakes up",
      ...> "[1518-11-01 00:30] falls asleep",
      ...> "[1518-11-01 00:55] wakes up",
      ...> "[1518-11-01 23:58] Guard #99 begins shift",
      ...> "[1518-11-02 00:40] falls asleep",
      ...> "[1518-11-02 00:50] wakes up",
      ...> "[1518-11-03 00:05] Guard #10 begins shift",
      ...> "[1518-11-03 00:24] falls asleep",
      ...> "[1518-11-03 00:29] wakes up",
      ...> "[1518-11-04 00:02] Guard #99 begins shift",
      ...> "[1518-11-04 00:36] falls asleep",
      ...> "[1518-11-04 00:46] wakes up",
      ...> "[1518-11-05 00:03] Guard #99 begins shift",
      ...> "[1518-11-05 00:45] falls asleep",
      ...> "[1518-11-05 00:55] wakes up",
      ...> ])
      4455
  """
  def part_two(input) do
    {_, sleep_ranges, _, _} = parse_file(input)

    {id, {min, _}} =
      sleep_ranges
      |> Enum.map(fn {k, ranges} ->
        highest_range =
          ranges
          |> Enum.flat_map(fn range -> for x <- range, do: x end)
          |> Enum.group_by(& &1)
          |> Enum.max_by(fn {_, counts} -> length(counts) end)

        {k, highest_range}
      end)
      |> Enum.max_by(fn {_, {_, counts}} -> length(counts) end)

    id * min
  end
end
