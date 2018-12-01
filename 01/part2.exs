File.stream!("input.txt")
|> Stream.cycle
|> Enum.reduce_while({0, MapSet.new()}, fn num, {curr, curr_set} ->
	{num, _} = Integer.parse(num)
	if MapSet.member?(curr_set, curr) do
		{:halt, curr}
	else
		set = MapSet.put(curr_set, curr)
		curr = curr + num
		{:cont, {curr, set}}
	end
end)
|> IO.inspect