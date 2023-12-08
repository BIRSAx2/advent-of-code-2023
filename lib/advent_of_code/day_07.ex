defmodule AdventOfCode.Day07 do
  @card_to_value %{
    "A" => 14,
    "K" => 13,
    "Q" => 12,
    "J" => 11, # set J to 1 for part 2
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

  @type_to_value %{
    high_card: 1,
    one_pair: 2,
    two_pairs: 3,
    three_of_a_kind: 4,
    full_house: 5,
    four_of_a_kind: 6,
    five_of_a_kind: 7
  }

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_hand/1)
  end

  defp parse_hand(hand) do
    [cards, bid] =
      String.split(hand, " ")

    bid = String.to_integer(bid)

    values =
      cards
      |> String.split("", trim: true)
      |> Enum.map(fn symol ->
        Map.get(@card_to_value, symol)
      end)

    hand_type =
      get_hand_type(values)

    %{
      bid: bid,
      values: values,
      hand: cards,
      hand_type: hand_type
    }
  end

  defp replace_jokers(card_values) do
    joker_value = Map.get(@card_to_value, "J")

    if Enum.member?(card_values, joker_value) do
      card_with_max_occurences =
        card_values
        |> Enum.filter(&(&1 != joker_value))
        |> then(fn values ->
          if values == [] do
            [14]
          else
            values
          end
        end)
        |> Enum.frequencies()
        |> Enum.max_by(fn {_, count} -> count end)
        |> elem(0)

      Enum.map(card_values, fn value ->
        if value == joker_value do
          card_with_max_occurences
        else
          value
        end
      end)
    else
      card_values
    end
  end

  defp get_hand_type(card_values) do
    card_values
    # |> replace_jokers() #uncomment this for part 2
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort()
    |> _hand_type()
  end

  defp _hand_type([1, 1, 1, 1, 1]), do: :high_card
  defp _hand_type([1, 1, 1, 2]), do: :one_pair
  defp _hand_type([1, 2, 2]), do: :two_pairs
  defp _hand_type([1, 1, 3]), do: :three_of_a_kind
  defp _hand_type([2, 3]), do: :full_house
  defp _hand_type([1, 4]), do: :four_of_a_kind
  defp _hand_type([5]), do: :five_of_a_kind

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
        Map.get(@type_to_value, hand_a.hand_type) < Map.get(@type_to_value, hand_b.hand_type)
      end
    end)
  end

  def part1(args) do
    args
    |> parse()
    |> sort()
    |> Enum.with_index()
    |> Enum.map(fn {hand, index} ->
      hand.bid * (index + 1)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    part1(args)
  end
end
