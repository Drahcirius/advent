ids =
  File.stream!("input.txt")
  |> Enum.map(&String.trim_trailing/1)

ids
|> Enum.reduce_while(ids, fn id, [_ | rest] ->
  split_id = String.split(id, "", trim: true)

  found =
    Enum.find(rest, fn val ->
      String.split(val, "", trim: true)
      |> Enum.zip(split_id)
      |> Enum.reduce(0, fn {a, b}, acc -> if a == b, do: acc, else: acc + 1 end)
      |> Kernel.==(1)
    end)

  if found do
    {:halt, {id, found}}
  else
    {:cont, rest}
  end
end)
|> (fn {a, b} ->
      a_split = a |> String.split("")
      b_split = b |> String.split("")

      Enum.zip(a_split, b_split)
      |> Enum.filter(fn {char1, char2} -> char1 == char2 end)
      |> Enum.map(fn {char, _} -> char end)
      |> Enum.join("")
      |> IO.inspect()
    end).()
