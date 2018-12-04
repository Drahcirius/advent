File.stream!("input.txt")
|> Enum.map(fn line ->
  [_ | matches] = Regex.run(~r/\[(.+)\] (.+)/, line)
  matches
end)
|> Enum.sort_by(&List.first/1, &</2)
|> Enum.reduce({%{}, %{}, nil, nil}, fn [time, text], {sleep_counter, sleep_ranges, id, timestamp} ->
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
|> (fn {sleep_counter, sleep_ranges, _, _} ->
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
    end).()
|> IO.inspect()
