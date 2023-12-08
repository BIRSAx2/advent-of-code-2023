defmodule AdventOfCode.Day05 do
  def map_number([], n), do: n

  def map_number([{range, _} = fun | maps], n) do
    if n in range do
      apply_fun(fun, n)
    else
      map_number(maps, n)
    end
  end

  def apply_fun({range, dest}, n), do: dest + n - range.first

  def process(input) do
    ["seeds: " <> seeds | maps] = input |> String.split("\n\n", trim: true)

    {parse_nums(seeds),
     maps
     |> Enum.map(fn map ->
       [_name, elements] = String.split(map, " map:\n")

       elements
       |> String.split("\n", trim: true)
       |> Enum.map(&parse_nums/1)
       |> Enum.map(&create_mapping/1)
     end)}
  end

  def create_mapping([dest, source, length]) do
    {source..(source + length - 1), dest}
  end

  def map_range(range, []), do: [range]

  def map_range(arg_range, [{fun_range, _} = fun_def | maps]) do
    if Range.disjoint?(fun_range, arg_range) do
      map_range(arg_range, maps)
    else
      fun_lo..fun_hi = fun_range
      arg_lo..arg_hi = arg_range
      lo = [fun_lo, arg_lo] |> Enum.max()
      hi = [fun_hi, arg_hi] |> Enum.min()

      [
        apply_fun(fun_def, lo)..apply_fun(fun_def, hi)
        | if(arg_lo < lo, do: map_range(arg_lo..(lo - 1), maps), else: []) ++
            if(hi < arg_hi, do: map_range((hi + 1)..arg_hi, maps), else: [])
      ]
    end
  end

  def map_ranges(ranges, []), do: normalize_ranges(ranges)

  def map_ranges(ranges, [map | maps]) do
    ranges
    |> normalize_ranges()
    |> Enum.map(fn arg -> map_range(arg, map) end)
    |> List.flatten()
    |> map_ranges(maps)
  end

  def normalize_ranges(ranges) do
    ranges
    |> Enum.sort()
    |> merge_ranges()
  end

  def merge_ranges([]), do: []
  def merge_ranges([a]), do: [a]

  def merge_ranges([a | [b | ranges]]) do
    if Range.disjoint?(a, b) do
      [a | merge_ranges([b | ranges])]
    else
      merge_ranges([Enum.min([a.first, b.first])..Enum.max(a.last, b.last) | ranges])
    end
  end

  def maps_number(n, maps) do
    Enum.reduce(maps, n, &map_number/2)
  end

  def parse_nums(nums),
    do: nums |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)

  def part1(input) do
    {seeds, maps} = process(input)
    Enum.map(seeds, &maps_number(&1, maps)) |> Enum.min()
  end

  def part2(input) do
    {seeds, maps} = process(input)

    seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start, length] -> start..(start + length - 1) end)
    |> map_ranges(maps)
    |> hd
    |> then(& &1.first)
  end
end
