defmodule Day06 do
  def read_input(path \\ 'input.txt') do
    File.read!(path) |>
    String.split("\n\n", trim: true) |>
    parse_input()
  end

  def parse_input(list) do
    list |> Enum.map(fn group ->
      group |> String.split("\n", trim: true)
    end)
  end

  def count_answers(list) do
    list |> Enum.reduce(0, fn answers, res ->
      res + (answers |> Enum.join("") |> String.graphemes() |> Enum.uniq() |> Enum.count())
    end)
  end

  def count_answers_bis(list) do
    list |> Enum.reduce(0, fn group, res ->
      first = group |> List.first() |> String.graphemes() |> MapSet.new()
      n = Enum.reduce(group, first, fn a, set ->
        m = String.graphemes(a) |> MapSet.new()
        MapSet.intersection(set, m)
      end) |> MapSet.size()
      n + res
    end)
  end
end
