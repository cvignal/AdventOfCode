defmodule Day17 do
  def read_input(path \\ 'input.txt') do
    File.stream!(path) |>
    Stream.map(&String.trim/1) |>
    parse_input()
  end

  def parse_input(stream) do
    stream |> Stream.with_index() |>
    Stream.map(fn {line, y_coord} ->
      line |> String.graphemes() |> Enum.with_index() |>
      Enum.filter(fn {cube, _x_coord} ->
        cube == "#"
      end) |>
      Enum.map(fn {_cube, x_coord} ->
        {x_coord, y_coord, 0, 0}
      end)
    end)
  end

  def neighbor_cubes?({x1, y1, z1, w1}, {x2, y2, z2, w2}) do
    abs(x1 - x2) <= 1 && abs(y1 - y2) <= 1 && abs(z1 - z2) <= 1 && abs(w1 - w2) <= 1
  end

  def generate_neighbors({x, y, z, w} = me) do
    all = for x <- (x - 1)..(x + 1), y <- (y - 1)..(y + 1), z <- (z - 1)..(z + 1), w <- (w - 1)..(w + 1), do: {x, y, z, w}
    all -- [me]
  end

  def cycle_state(state) do
    old_alive_cubes = state |> MapSet.new()
    new_alive_cubes = Enum.reduce(old_alive_cubes, old_alive_cubes, fn {x, y, z, w}, set ->
      nset = Day11.generate_neighbors({x, y, z, w}) |> MapSet.new()
      MapSet.union(set, nset)
    end) |> Enum.filter(fn new_cube ->
      nb = Enum.filter(old_alive_cubes, fn old_cube -> Day11.neighbor_cubes?(old_cube, new_cube) end) |> Enum.count()
      nb == 3 && !MapSet.member?(old_alive_cubes, new_cube)
    end)
    old_alive_cubes |> Enum.filter(fn old_cube ->
      nb = Enum.filter(old_alive_cubes, fn c -> c != old_cube && neighbor_cubes?(c, old_cube) end) |> Enum.count()
      nb in [2, 3]
    end) |> Enum.concat(new_alive_cubes)
  end

  def cycle(state, 0), do: state
  def cycle(state, n), do: cycle(cycle_state(state), n - 1)

  def count_alive_cubes(path \\ 'input.txt') do
    read_input(path) |>
    Enum.to_list() |> List.flatten() |> cycle(6) |> Enum.count()
  end
end
