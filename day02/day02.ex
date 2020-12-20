defmodule Day02 do
  use Bitwise

  def read_input() do
    File.read!('input.txt') |>
    String.split("\n", trim: true) |>
    parse_input()
  end

  def parse_input(list) do
    Enum.map(list, fn line ->
      [numbers, letter, password] = line |> String.split(" ")
      numbers = numbers |> String.split("-")
      min = numbers |> List.first() |> String.to_integer()
      max = numbers |> List.last() |> String.to_integer()
      %{
        min: min,
        max: max,
        letter: letter |> String.slice(0, 1),
        password: password
      }
    end)
  end

  def validate_passwords(list) do
    Enum.filter(list, fn elt ->
      count = elt[:password] |> String.graphemes() |> Enum.count(&(&1 == elt[:letter]))
      (count >= elt[:min]) && (count <= elt[:max])
    end) |> Enum.count()
  end

  def validate_passwords_bis(list) do
    Enum.filter(list, fn elt ->
      p1 = String.at(elt[:password], elt[:min] - 1) == elt[:letter]
      p2 = String.at(elt[:password], elt[:max] - 1) == elt[:letter]
      cond do
        p1 && p2 -> false
        p1 && !p2 -> true
        !p1 && p2 -> true
        !p1 && !p2 -> false
      end
    end) |> Enum.count()
  end
end
