defmodule AdventOfCode.Day06 do
  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
  end

  defp compute_way_to_beat_record({time, distance}) do
    b1 = (time + :math.sqrt(time * time - 4 * distance)) / 2
    b2 = (time - :math.sqrt(time * time - 4 * distance)) / 2

    (floor(b2) - ceil(b1) + 1) * - 1
  end

  def part1(args) do
      parse(args)
      |> Enum.map(&compute_way_to_beat_record/1)
      |> Enum.reduce(1, fn x, acc -> acc * x end)
  end


  defp parse_part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.drop(1)
      |> Enum.join("")
      |> String.to_integer()
    end)
    |> then(fn [time, distance] ->
      {time, distance}
    end)
  end
  def part2(args) do
    args
    |> parse_part2()
    |> compute_way_to_beat_record()
  end
end
