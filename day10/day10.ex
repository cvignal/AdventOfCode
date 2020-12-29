defmodule Day10 do
  @rating_base 0
  def read_input(path \\ 'input.txt') do
    File.stream!(path) |>
    Stream.map(&String.trim/1) |>
    parse_input()
  end

  def parse_input(stream) do
    stream |> Stream.map(&String.to_integer/1)
  end

  def find_differences(input) do
    input |> Enum.sort() |> Enum.reduce(%{one_diff: 0, three_diff: 1, prev_capacity: @rating_base}, fn nb, acc ->
      diff = nb - acc[:prev_capacity]
      %{
        one_diff: acc[:one_diff] + (if diff == 1, do: 1, else: 0),
        three_diff: acc[:three_diff] + (if diff == 3, do: 1, else: 0),
        prev_capacity: nb
      }
    end)
  end

  def calc_nb_comb(input) do
    {:ok, memo} = Agent.start(fn -> %{} end)
    input |>
    Enum.sort() |>
    memo_find_comb(0, memo)
  end

  def memo_find_comb(list, curr, memo) do
    case Agent.get(memo, &Map.get(&1, {list, curr})) do
      nil ->
        res = find_comb(list, curr, memo)
        Agent.update(memo, &Map.put(&1, {list, curr}, res))
        res
      res ->
         res
    end
  end

  def find_comb([], _, _), do: 1

  def find_comb(list, curr, memo) do
    list |>
    Enum.slice(0..2) |>
    Enum.with_index() |>
    Enum.filter(fn {nb, _} -> nb - curr <= 3 end) |>
    Enum.map(fn {nb, idx} ->
      {nb, Enum.slice(list, (idx + 1)..-1)}
    end) |>
    Enum.map(fn {nb, tail} ->
      memo_find_comb(tail, nb, memo)
    end) |>
    Enum.sum()
  end
end
