File.stream!("input.txt")
|> Enum.reduce(0, fn num, acc ->
  {num, _} = Integer.parse(num)
  acc + num
end)
|> IO.inspect()
