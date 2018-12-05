defmodule Advent do
  @callback part_one(list) :: term()
  @callback part_two(list) :: term()

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour Advent

      @spec get_file :: [String.t()]
      def get_file do
        file_name = Keyword.get(unquote(Macro.escape(opts)), :file)

        file =
          "inputs/#{file_name}"
          |> File.read!()
          |> String.split("\n", trim: true)
      end

      @spec solve :: {term(), term()}
      def solve do
        file = get_file()
        {part_one(file), part_two(file)}
      end

      @spec bench(integer()) :: :ok
      def bench(repeat \\ 1) do
        file = get_file()

        [part_ones, part_twos] =
          Enum.reduce(1..repeat, [[], []], fn _, [part_one_times, part_two_times] ->
            {time1, _} = :timer.tc(__MODULE__, :part_one, [file])
            {time2, _} = :timer.tc(__MODULE__, :part_two, [file])

            [[time1 | part_one_times], [time2 | part_two_times]]
          end)

        IO.puts("""
        Over #{repeat} iterations
        Part 1 average: #{div(Enum.sum(part_ones), length(part_ones) * 1000)}ms
        Part 2 average: #{div(Enum.sum(part_twos), length(part_twos) * 1000)}ms
        """)
      end
    end
  end
end
