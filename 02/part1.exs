File.stream!("input.txt")
|> Enum.reduce({0, 0}, fn str, {twos, threes} ->
  str_map =
    str
    |> String.split("", trim: true)
    |> Enum.group_by(& &1)

  twos = if Enum.any?(str_map, fn {_, v} -> length(v) == 2 end), do: twos + 1, else: twos
  threes = if Enum.any?(str_map, fn {_, v} -> length(v) == 3 end), do: threes + 1, else: threes
  {twos, threes}
end)
|> (fn {twos, threes} ->
      IO.inspect(twos * threes)
    end).()
