File.stream!("input.txt")
|> Enum.map(fn line ->
  [_ | nums] = Regex.run(~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/, line)
  Enum.map(nums, &String.to_integer/1)
end)
|> Enum.reduce(%{}, fn [id, x, y, width, height], cloth ->
  for n <- 0..(width * height - 1) do
    {x + rem(n, width), y + trunc(n / width)}
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
|> IO.inspect()
