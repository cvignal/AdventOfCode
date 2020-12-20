defmodule Day01 do
  def read_input() do
    File.read!('input.txt') |>
    String.split("\n", trim: true) |>
    Enum.map(fn nb -> String.to_integer(nb) end)
  end

  def find_couple(list, sum \\ 2020) do
    list = list |> Enum.sort()
    Enum.reduce_while(list, list, fn nb, acc ->
      acc = acc |> Enum.reject(fn n -> n + nb > sum end)
      if acc != [] && List.last(acc) + nb == sum do
        {:halt, {List.last(acc), nb}}
      else
        {:cont, acc}
      end
    end)
  end

  def find_triple(list) do
    first_nb = list |> Enum.min()
    list = list |> Enum.sort() |> Enum.slice(1..-1)
    Enum.reduce_while(list, %{list: list, nb: first_nb}, fn nb, acc ->
      res = find_couple(acc[:list], 2020 - first_nb)
      if is_tuple(res) do
        {:halt, {first_nb, res}}
      else
        {:cont, %{list: acc[:list] |> Enum.slice(1..-1), nb: acc[:list] |> List.first()}}
      end
    end)
  end
end
