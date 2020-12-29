defmodule Day08 do
  def read_input(path \\ 'input.txt') do
    File.read!(path) |>
    String.split("\n", trim: true) |>
    parse_input()
  end

  def parse_input(list) do
    list |> Enum.map(fn line ->
      content = line |> String.split(" ")
      instruction = content |> List.first() |> String.to_atom()
      nb = content |> List.last() |> String.to_integer()
      %{
        instruction: instruction,
        nb: nb,
        executed: false,
      }
    end)
  end


  def exec_instr(idx, prog, acc) do
    instr = prog[idx]
    cond do
      instr[:executed] -> {:error, acc}
      instr == nil -> {:ok, acc}
      true ->
        instr = instr |> Map.merge(%{executed: true})
        prog = prog |> Map.merge(%{idx => instr})
        case instr[:instruction] do
          :nop ->
            exec_instr(idx + 1, prog, acc)
          :acc ->
            exec_instr(idx + 1, prog, acc + instr[:nb])
          :jmp ->
            exec_instr(idx + instr[:nb], prog, acc)
          _ ->
            {:ok, acc}
        end
    end
  end

  def change_instr(idx, prog, acc) do
    instr = prog[idx]
    if instr[:instruction] != :acc do
      new_instruction = if instr[:instruction] == :jmp, do: :nop, else: :jmp
      new_instr = instr |> Map.merge(%{instruction: new_instruction})
      new_prog = prog |> Map.merge(%{idx => new_instr})
      case exec_instr(idx, new_prog, acc) do
        {:ok, res} -> res
        {:error, _} ->
          instr = instr |> Map.merge(%{executed: true})
          prog = prog |> Map.merge(%{idx => instr})
          case instr[:instruction] do
            :jmp ->
              change_instr(idx + instr[:nb], prog, acc)
            :nop ->
              change_instr(idx + 1, prog, acc)
          end
      end
    else
      instr = instr |> Map.merge(%{executed: true})
      prog = prog |> Map.merge(%{idx => instr})
      change_instr(idx + 1, prog, acc + instr[:nb])
    end
  end

  def acc_before_infinite(list) do
    prog = list |> Enum.with_index() |> Enum.map(fn {l, i} -> {i, l} end) |> Enum.into(%{})
    exec_instr(0, prog, 0)
  end

  def find_instr(list) do
    prog = list |> Enum.with_index() |> Enum.map(fn {l, i} -> {i, l} end) |> Enum.into(%{})
    change_instr(0, prog, 0)
  end
end
