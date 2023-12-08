defmodule AdventOfCode.Day07 do
  @card_to_value %{
    "A" => 14,
    "K" => 13,
    "Q" => 12,
    "J" => 11,
    "T" => 10,
    "9" => 9,
    "8" => 8,
    "7" => 7,
    "6" => 6,
    "5" => 5,
    "4" => 4,
    "3" => 3,
    "2" => 2
  }

  @hand_type_value %{
    :high_card => 1,
    :one_pair => 2,
    :two_pairs => 3,
    :three_of_a_kind => 4,
    :full_house => 5,
    :four_of_a_kind => 6,
    :five_of_a_kind => 7
  }

  @hand_type_from_freq %{
    [1, 1, 1, 1, 1] => :high_card,
    [2, 1, 1, 1] => :one_pair,
    [2, 2, 1] => :two_pairs,
    [3, 1, 1] => :three_of_a_kind,
    [3, 2] => :full_house,
    [4, 1] => :four_of_a_kind,
    [5] => :five_of_a_kind
  }

  defp parse(input, account_for_jokers: account_for_jokers) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_hand/1)
    |> Enum.map(fn hand ->
      hand
      |> Map.put(:values, symbols_to_values(hand[:hand], account_for_jokers))
      |> then(fn hand ->
        Map.put(hand, :hand_type, get_hand_type(hand[:values], account_for_jokers))
      end)
    end)
  end

  defp parse_hand(hand) do
    [cards, bid] =
      String.split(hand, " ")

    %{
      bid: String.to_integer(bid),
      values: nil,
      hand: cards,
      hand_type: nil
    }
  end

  defp symbols_to_values(hand, false) do
    hand
    |> String.split("", trim: true)
    |> Enum.map(&Map.get(@card_to_value, &1))
  end

  defp symbols_to_values(hand, true) do
    hand
    |> String.split("", trim: true)
    |> Enum.map(&Map.get(Map.put(@card_to_value, "J", 1), &1))
  end

  defp replace_jokers(card_values) do
    joker_value = 1

    if Enum.member?(card_values, joker_value) do
      card_with_max_occurences =
        card_values
        |> Enum.filter(&(&1 != joker_value))
        |> then(&if &1 == [], do: [14], else: &1)
        |> Enum.frequencies()
        |> Enum.max_by(fn {_, count} -> count end)
        |> elem(0)

      Enum.map(card_values, fn value ->
        if value == joker_value, do: card_with_max_occurences, else: value
      end)
    else
      card_values
    end
  end

  defp get_hand_type(hand_values, replace_jokers) do
    hand_values
    |> then(&if replace_jokers, do: replace_jokers(&1), else: &1)
    |> Enum.group_by(& &1)
    |> Enum.map(fn {_, values} ->
      Enum.count(values)
    end)
    |> Enum.sort()
    |> Enum.reverse()
    |> then(&Map.get(@hand_type_from_freq, &1))
  end

  def compare_hands([], []), do: :eq

  def compare_hands([head1 | tail1], [head2 | tail2]) do
    cond do
      head1 < head2 -> :lt
      head1 > head2 -> :gt
      true -> compare_hands(tail1, tail2)
    end
  end

  defp sort(hands) do
    Enum.sort(hands, fn hand_a, hand_b ->
      if hand_a.hand_type == hand_b.hand_type do
        compare_hands(hand_a.values, hand_b.values) == :lt
      else
        Map.get(@hand_type_value, hand_a.hand_type) < Map.get(@hand_type_value, hand_b.hand_type)
      end
    end)
  end

  defp winnings(hands) do
    hands
    |> Enum.with_index()
    |> Enum.map(fn {hand, index} ->
      hand.bid * (index + 1)
    end)
    |> Enum.sum()
  end

  def part1(args) do
    args
    |> parse(account_for_jokers: false)
    |> sort()
    |> winnings()
  end

  def part2(args) do
    args
    |> parse(account_for_jokers: true)
    |> sort()
    |> winnings()
  end
end
