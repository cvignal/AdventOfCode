defmodule Day03 do
  def read_input(path \\ 'input.txt') do
    File.read!(path) |>
    String.split("\n", trim: true)
  end

  # 67 211 77 89 37
  def nb_trees(list) do
    length = list |> List.first() |> String.length()
    Enum.reduce(list, %{nb: 0, x: 0, y: 0, idx: 0}, fn line, acc ->
      pos = rem(acc[:x], length)
      if rem(acc[:idx], 2) == 0 do
        %{
          nb: acc[:nb] + (if String.at(line, pos) == "#", do: 1, else: 0),
          x: acc[:x] + 1,
          y: acc[:y] + 2,
          idx: acc[:idx] + 1,
        }
      else
        %{
          nb: acc[:nb],
          x: acc[:x],
          y: acc[:y],
          idx: acc[:idx] + 1,
        }
      end
    end)
  end
end
