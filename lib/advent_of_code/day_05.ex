defmodule AdventOfCode.Day05 do
  defp parse(input) do
    [seeds | maps] =
      String.split(input, "\n\n", trim: true)

    seeds =
      parse_seeds(seeds)

    maps =
      Enum.map(maps, &parse_map/1)
      |> Map.new()

    %{seeds: seeds, maps: maps}
  end

  defp parse_seeds(seeds) do
    seeds
    |> String.replace("seeds: ", "")
    |> parse_row()
  end

  defp parse_map(map) do
    [name | rows] =
      String.split(map, "\n", trim: true)

    name =
      String.replace(name, " map:", "")
      |> String.replace("-", "_")
      |> String.replace(" ", "_")
      |> String.downcase()

    rows =
      Enum.map(rows, &parse_row/1)
      |> Enum.map(&to_range/1)

    {String.to_atom(name), rows}
  end

  defp to_range([d_start, s_start, offset]) do
    %{
      destination: d_start..(d_start + offset - 1),
      source: s_start..(s_start + offset - 1)
    }
  end

  defp parse_row(row) do
    row
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp translate(seed, mappings) do
    range =
      Enum.find(mappings, fn mapping ->
        seed in mapping.source
      end)

    if range == nil do
      seed
    else
      ss.._ = range.source
      ds.._ = range.destination

      seed - ss + ds
    end
  end


  defp find_lowest_location(almanac) do
    almanac.seeds
    |> Enum.map(fn seed ->
      seed
      |> translate(almanac.maps.seed_to_soil)
      |> translate(almanac.maps.soil_to_fertilizer)
      |> translate(almanac.maps.fertilizer_to_water)
      |> translate(almanac.maps.water_to_light)
      |> translate(almanac.maps.light_to_temperature)
      |> translate(almanac.maps.temperature_to_humidity)
      |> translate(almanac.maps.humidity_to_location)
    end)
    |> Enum.min()
  end

  def part1(args) do
    args
    |> parse()
    |> find_lowest_location()
  end

  defp find_lowest_location_part2(almanac) do
    almanac.seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start, offset] ->
      start..(start + offset - 1)
      |> Range.to_list()
    end)
    |> IO.inspect()
    |> List.flatten()
    |> Enum.map(fn seed ->
      seed
      |> translate(almanac.maps.seed_to_soil)
      |> translate(almanac.maps.soil_to_fertilizer)
      |> translate(almanac.maps.fertilizer_to_water)
      |> translate(almanac.maps.water_to_light)
      |> translate(almanac.maps.light_to_temperature)
      |> translate(almanac.maps.temperature_to_humidity)
      |> translate(almanac.maps.humidity_to_location)
    end)
    |> Enum.min()
  end

  def part2(args) do
    # What about the reverse approach, check which humidity results in the lowest location, then which temperature result in that humidity, etc.
    args
    |> parse()
    |> find_lowest_location_part2()
  end
end
