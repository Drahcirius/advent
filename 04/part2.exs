File.stream!("input.txt")
|> Enum.map(fn line ->
  "[" <> <<date::binary-size(16)>> <> "] " <> text = line
  {date, String.trim_trailing(text)}
end)
|> Enum.sort_by(&elem(&1, 0), &</2)
|> Enum.reduce({%{}, nil, nil}, fn {time, text}, {sleep_ranges, id, timestamp} ->
  case text do
    "Guard #" <> rest ->
      {id, _} = Integer.parse(rest)
      {sleep_ranges, id, timestamp}

    "falls asleep" ->
      {sleep_ranges, id, time}

    "wakes up" ->
      begin_time = timestamp |> binary_part(14, 2) |> String.to_integer()
      end_time = time |> binary_part(14, 2) |> String.to_integer()

      range = begin_time..(end_time - 1)
      sleep_ranges = Map.update(sleep_ranges, id, [range], &[range | &1])
      {sleep_ranges, id, time}
  end
end)
|> (fn {sleep_ranges, _, _} ->
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
    end).()
|> IO.inspect()
