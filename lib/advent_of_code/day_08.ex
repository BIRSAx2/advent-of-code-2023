defmodule AdventOfCode.Day08 do
  defp parse(input) do
    String.split(input, "\n\n", trim: true)
    |> then(fn [directions, nodes] ->
      %{
        directions: parse_directions(directions),
        nodes: parse_nodes(nodes)
      }
    end)
  end

  defp parse_directions(directions) do
    directions
    |> String.split("", trim: true)
    |> Enum.map(fn
      "L" -> :left
      "R" -> :right
    end)
  end

  defp parse_nodes(nodes) do
    nodes
    |> String.split("\n", trim: true)
    |> Enum.map(fn node ->
      node
      |> String.split(" = ", trim: true)
      |> then(fn [node, value] ->
        {
          node,
          parse_node_value(value)
        }
      end)
    end)
    |> Map.new()
  end

  defp parse_node_value(value) do
    value
    |> String.replace(["(", ")", " "], "")
    |> String.split(",")
    |> then(fn [left, right] ->
      %{
        left: left,
        right: right
      }
    end)
  end

  def part1(args) do
    args
    |> parse()
    |> traverse_and_count_steps("AAA", &(&1 == "ZZZ"))
  end

  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: trunc(a * b / gcd(a, b))

  defp traverse_and_count_steps(graph, start, finish_condition) do
    Stream.cycle(graph.directions)
    |> Enum.reduce_while({Map.get(graph.nodes, start), 0}, fn direction, {current, steps} ->
      next_node =
        Map.get(current, direction)

      cond do
        finish_condition.(next_node) -> {:halt, {next_node, steps + 1}}
        true -> {:cont, {Map.get(graph.nodes, next_node), steps + 1}}
      end
    end)
    |> elem(1)
  end

  defp multiple_traverse(graph, starting_points) do
    [first | rest] =
      starting_points
      |> Enum.map(fn start ->
        traverse_and_count_steps(graph, start, &String.ends_with?(&1, "Z"))
      end)

    rest
    |> Enum.reduce(first, &lcm(&1, &2))
    |> trunc()
  end

  def part2(args) do
    graph = parse(args)
    starting_points = Map.keys(graph.nodes) |> Enum.filter(&String.ends_with?(&1, "A"))
    multiple_traverse(graph, starting_points)
  end
end
