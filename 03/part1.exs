File.stream!("input.txt")
|> Enum.map(fn line ->
  [_ | nums] = Regex.run(~r/#\d+ @ (\d+),(\d+): (\d+)x(\d+)/, line)
  Enum.map(nums, &String.to_integer/1)
end)
|> Enum.reduce(%{}, fn [x, y, width, height], cloth ->
  for rx <- x..(x + width - 1),
      ry <- y..(y + height - 1) do
    {rx, ry}
  end
  |> Enum.reduce(cloth, fn coord, cloth_acc ->
    Map.update(cloth_acc, coord, :placed, fn _ -> :overlap end)
  end)
end)
|> Enum.count(fn {_, v} -> v == :overlap end)
|> IO.inspect()
