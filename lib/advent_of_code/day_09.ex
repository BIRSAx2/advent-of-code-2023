defmodule AdventOfCode.Day09 do
  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn history ->
      Enum.map(history, &String.to_integer/1)
    end)
  end

  defp step_diffs(history) do
    Enum.reduce_while(history, [history], fn _, acc ->
      result =
        hd(acc)
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(&(List.last(&1) - hd(&1)))

      if Enum.all?(result, &(&1 == 0)) do
        {:halt, acc}
      else
        {:cont, [result | acc]}
      end
    end)
    |> Enum.with_index()
    |> Enum.map(fn {result, index} ->
      {index, result}
    end)
    |> Map.new()
  end

  defp complete_triangles(history, :right) do
    history
    |> Map.keys()
    |> Enum.sort(:asc)
    |> Enum.reduce(history, fn key, acc ->
      if Map.has_key?(acc, key - 1) do
        last = acc[key - 1] |> List.last()
        Map.put(acc, key, acc[key] ++ [List.last(acc[key]) + last])
      else
        Map.put(acc, key, acc[key] ++ [List.last(acc[key])])
      end
    end)
  end

  defp complete_triangles(history, :left) do
    history
    |> Map.keys()
    |> Enum.sort(:asc)
    |> Enum.reduce(history, fn key, acc ->
      if Map.has_key?(acc, key - 1) do
        first = acc[key - 1] |> hd()
        Map.put(acc, key, [hd(acc[key]) - first | acc[key]])
      else
        Map.put(acc, key, [hd(acc[key]) | acc[key]])
      end
    end)
  end

  def part1(args) do
    args
    |> parse()
    |> Enum.map(&step_diffs/1)
    |> Enum.map(&complete_triangles(&1, :right))
    |> Enum.map(fn history ->
      history
      |> Map.values()
      |> List.last()
      |> List.last()
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse()
    |> Enum.map(&step_diffs/1)
    |> Enum.map(&complete_triangles(&1, :left))
    |> Enum.map(fn history ->
      history
      |> Map.values()
      |> List.last()
      |> List.first()
    end)
    |> Enum.sum()
  end
end
