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
        parent_color: color,
        children: children
      }
    end)
  end

  def build_tree(color, rules) do
  end
end
