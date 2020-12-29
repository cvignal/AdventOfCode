defmodule Day07 do
  def read_input(path \\ 'input.txt') do
    File.read!(path) |>
    String.split("\n", trim: true) |>
    parse_input()
  end

  def parse_input(list) do
    list |> Enum.map(fn rule ->
      color = String.split(rule, " ") |> Enum.slice(0, 2) |> Enum.join(" ")
      children = String.split(rule, "contain") |> List.last()
      children = if children == " no other bags." do
        []
      else
        String.split(children, ",") |> Enum.map(fn child ->
          elements = String.split(child, " ", trim: true)
          number = elements |> List.first() |> String.to_integer()
          color = elements |> Enum.slice(1, 2) |> Enum.join(" ")
          %{
            nb: number,
            color: color
          }
        end)
      end
      %{
        color: color,
        children: children
      }
    end)
  end

  def find_parents(rules, color) do
    Enum.reduce_while(rules, [], fn rule, acc->
      if rule[:color] != color do
        present? = rule[:children] |> Enum.find(fn c -> c[:color] == color end)
        if present? do
          acc = Enum.concat(acc, [rule[:color]])
          parents = find_parents(rules, rule[:color])
          {:cont, Enum.concat(acc, parents)}
        else
          {:cont, acc}
        end
      else
        {:cont, acc}
      end
    end)
  end

  def find_children(rules, color, color_first) do
    Enum.reduce(rules, 1, fn rule, res ->
      if rule[:color] == color do
        sum = Enum.reduce(rule[:children], 0, fn child, acc ->
          if child[:color] != color_first do
            acc + child[:nb] * find_children(rules, child[:color], color_first)
          else
            acc
          end
        end)
        res + sum
      else
        res
      end
    end)
  end
end
