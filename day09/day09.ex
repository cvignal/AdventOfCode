defmodule Day09 do
  def read_input(path \\ 'input.txt') do
    File.stream!(path) |>
    Stream.map(&String.trim/1) |>
    parse_input()
  end

  def parse_input(stream) do
    stream |> Stream.map(&String.to_integer/1)
  end

  def combine

  def find_error(input, size \\ 25) do
    input |>
    Stream.chunk_every(size + 1, 1) |>
    Enum.find_value(fn list ->
      {total, options} = List.pop_at(list, -1)

      combinations = for i <- options, j <- options, uniq: true do
      [i, j] |> Enum.sort() |> List.to_tuple()
      end
      valid? = Enum.any?(combinations, fn {i, j} -> i + j == total end)
      unless valid?, do: total
    end)
  end

  def find_contig(input, search) do
    input |>
    Stream.chunk_while(:queue.new(), chunk_fun_queue(search), &after_fun/1) |>
    Enum.at(0)
  end

  defp after_fun(acc), do: {:cont, acc}

  defp chunk_fun_queue(total) do
    fn element, acc ->
      with_element = :queue.in(element, acc)
      check_sum_queue(with_element, total)
    end
  end

  defp check_sum_queue(with_element, total) do
    case with_element |> :queue.to_list() |> Enum.sum() do
      ^total ->
        {_, rest} = :queue.out(with_element)
        {:cont, with_element |> :queue.to_list(), rest}

      t when t < total ->
        {:cont, with_element}

      t when t > total ->
        {_, rest} = :queue.out(with_element)
        check_sum_queue(rest, total)
    end
  end
end
