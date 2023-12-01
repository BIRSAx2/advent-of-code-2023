defmodule AdventOfCode.Day01 do
  def extract_digits(<<>>), do: <<>>
  def extract_digits(<<x, rest::binary>>) when x in ?1..?9, do: <<x>> <> extract_digits(rest)

  def extract_digits(<<_x, rest::binary>>), do: extract_digits(rest)

  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&extract_digits/1)
    |> Enum.map(fn line ->
      digits = String.codepoints(line)
      List.first(digits) <> List.last(digits)
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def expand_and_extract_digits(<<>>), do: <<>>

  def expand_and_extract_digits(<<x, rest::binary>>) when x in ?1..?9,
    do: <<x>> <> expand_and_extract_digits(rest)

  def expand_and_extract_digits(<<"one", rest::binary>>),
    do: "1" <> expand_and_extract_digits("e" <> rest)

  def expand_and_extract_digits(<<"two", rest::binary>>),
    do: "2" <> expand_and_extract_digits("o" <> rest)

  def expand_and_extract_digits(<<"three", rest::binary>>),
    do: "3" <> expand_and_extract_digits("e" <> rest)

  def expand_and_extract_digits(<<"four", rest::binary>>),
    do: "4" <> expand_and_extract_digits("r" <> rest)

  def expand_and_extract_digits(<<"five", rest::binary>>),
    do: "5" <> expand_and_extract_digits("e" <> rest)

  def expand_and_extract_digits(<<"six", rest::binary>>),
    do: "6" <> expand_and_extract_digits("x" <> rest)

  def expand_and_extract_digits(<<"seven", rest::binary>>),
    do: "7" <> expand_and_extract_digits("n" <> rest)

  def expand_and_extract_digits(<<"eight", rest::binary>>),
    do: "8" <> expand_and_extract_digits("t" <> rest)

  def expand_and_extract_digits(<<"nine", rest::binary>>),
    do: "9" <> expand_and_extract_digits("e" <> rest)

  def expand_and_extract_digits(<<_, rest::binary>>), do: expand_and_extract_digits(rest)

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&expand_and_extract_digits/1)
    |> Enum.map(fn line ->
      digits = String.codepoints(line)
      List.first(digits) <> List.last(digits)
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
