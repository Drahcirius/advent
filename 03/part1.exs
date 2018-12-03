File.stream!("input.txt")
|> Enum.map(fn line ->
  [_ | nums] = Regex.run(~r/#\d+ @ (\d+),(\d+): (\d+)x(\d+)/, line)
  Enum.map(nums, &String.to_integer/1)
end)
|> Enum.reduce(%{}, fn [x, y, width, height], cloth ->
  for n <- 0..(width * height - 1) do
    {x + rem(n, width), y + trunc(n / width)}
  end
  |> Enum.reduce(cloth, fn coord, cloth_acc ->
    Map.update(cloth_acc, coord, :placed, fn _ -> :overlap end)
  end)
end)
|> Enum.count(fn {_, v} -> v == :overlap end)
|> IO.inspect()
