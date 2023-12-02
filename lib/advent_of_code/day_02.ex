defmodule AdventOfCode.Day02 do
  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_game/1)
  end

  defp parse_game(game) do
    [game, subsets] = String.split(game, ": ")
    ["Game", game_id] = String.split(game, " ")

    cubes =
      subsets
      |> String.split("; ")
      |> Enum.map(&parse_cube/1)

    %{game_id: String.to_integer(game_id), cubes: cubes}
  end

  defp parse_cube(cube) do
    cube
    |> String.split(", ")
    |> Enum.map(&parse_color_count/1)
    |> Map.new()
  end

  defp parse_color_count(color_count) do
    [count, color] = String.split(color_count, " ")
    {String.to_atom(color), String.to_integer(count)}
  end

  defp count_possible_games(games, constraints) do
    games
    |> Enum.filter(&game_satisfies_constraints?(&1, constraints))
  end

  defp game_satisfies_constraints?(game, constraints) do
    game.cubes
    |> Enum.map(&cube_satisfies_constraints?(&1, constraints))
    |> Enum.all?()
  end

  defp cube_satisfies_constraints?(cube, constraints) do
    Enum.all?(constraints, fn {color, count} ->
      Map.get(cube, color, 0) <= count
    end)
  end

  def part1(input) do
    input
    |> parse()
    |> count_possible_games(%{red: 12, green: 13, blue: 14})
    |> Enum.map(& &1.game_id)
    |> Enum.sum()
  end

  defp fewest_cubes(games) do
    games
    |> Enum.map(&calculate_max_cube_counts/1)
  end

  defp calculate_max_cube_counts(game) do
    game.cubes
    |> Enum.reduce(%{}, fn set, acc ->
      Map.merge(acc, set, fn _, count1, count2 ->
        max(count1, count2)
      end)
    end)
  end

  defp compute_power_of_sets(sets) do
    sets
    |> Enum.map(&calculate_power_of_set/1)
  end

  defp calculate_power_of_set(%{red: red, green: green, blue: blue}) do
    red * green * blue
  end

  def part2(input) do
    input
    |> parse()
    |> fewest_cubes()
    |> compute_power_of_sets()
    |> Enum.sum()
  end
end
