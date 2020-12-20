defmodule Day05 do
  def read_input(path \\ 'input.txt') do
    File.read!(path) |>
    String.split("\n", trim: true) |>
    parse_input()
  end

  def parse_input(list) do
    Enum.map(list, fn elt ->
      [row_code] = String.slice(elt, 0, 7) |> find_row()
      [column_code] = String.slice(elt, 7, 9) |> find_column()
      %{
        row: row_code,
        column: column_code,
        seat_id: row_code * 8 + column_code,
      }
    end)
  end

  def find_row(code) do
    String.graphemes(code) |> Enum.reduce(0..127, fn letter, rows ->
      middle = Enum.count(rows) |> div(2)
      case letter do
        "F" ->
          Enum.slice(rows, 0, middle)
        "B" ->
          Enum.slice(rows, middle..-1)
      end
    end)
  end

  def find_column(code) do
    String.graphemes(code) |> Enum.reduce(0..7, fn letter, columns ->
      middle = Enum.count(columns) |> div(2)
      case letter do
        "R" ->
          Enum.slice(columns, middle..-1)
        "L" ->
          Enum.slice(columns, 0, middle)
      end
    end)
  end

  def find_seat(list) do
    list = Enum.map(list, fn seat -> seat[:seat_id] end) |> Enum.sort()
    Enum.with_index(list) |> Enum.reduce_while(0, fn {id, idx}, _acc ->
      if idx == 0 do
        {:cont, 0}
      else
        cond do
          Enum.at(list, idx - 1) == id - 1 && Enum.at(list, idx + 1) == id + 1 -> {:cont, 0}
          true -> {:halt, id}
        end
      end
    end)
  end
end
