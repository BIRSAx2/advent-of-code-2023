defmodule AdventOfCode.Day04 do
  defp match_card(str) do
    regex_pattern =
      ~r/^Card\s+(?<card_id>\d+):\s(?<winning>(\d+|\s)+)\s\|\s(?<numbers>(\d+|\s)+)$/

    captures =
      Regex.named_captures(regex_pattern, str)

    %{
      card_id: String.to_integer(captures["card_id"]),
      winning_numbers: parse_numbers(captures["winning"]),
      numbers: parse_numbers(captures["numbers"])
    }
  end

  defp parse_numbers(numbers) do
    numbers
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&match_card/1)
  end

  defp find_winning_numbers(card) do
    card.numbers
    |> Enum.filter(&(&1 in card.winning_numbers))
    |> then(&%{card_id: card.card_id, winning_numbers: &1, count: Enum.count(&1)})
  end

  defp calculate_points(scratch_card) do
    numbers = scratch_card.winning_numbers

    if Enum.empty?(numbers) do
      0
    else
      numbers
      |> Enum.drop(1)
      |> Enum.reduce(1, fn _, acc ->
        acc * 2
      end)
    end
  end

  def part1(input) do
    input
    |> parse()
    |> Enum.map(&find_winning_numbers/1)
    |> Enum.map(&calculate_points/1)
    |> Enum.sum()
  end

  defp compute(cards) do
    cards
    |> Enum.reduce(%{}, fn card, acc ->
      count =
        card.card_id..(card.card_id + card.count)
        |> Enum.map(fn id ->
          Map.get(acc, id, 0)
        end)
        |> Enum.sum()

      Map.put(acc, card.card_id, count + 1)
    end)
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(&find_winning_numbers/1)
    |> Enum.reverse()
    |> compute()
    |> Map.values()
    |> Enum.sum()
  end
end
