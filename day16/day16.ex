defmodule Day16 do
  @rating_base 0
  def read_input(path \\ 'input.txt') do
    File.read!(path) |>
    String.split("\n\n", trim: true) |>
    parse_input()
  end

  def parse_ticket(line) do
    line |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  def parse_input(input) do
    rules = input |> List.first() |>
    String.split("\n", trim: true) |>
    Enum.map(fn rule ->
      rule = rule |> String.split(": ")
      name = rule |> List.first() |> String.to_atom
      ranges = rule |> List.last() |> String.split(" or ") |> Enum.map(fn range ->
        range = range |> String.split("-")
        (List.first(range) |> String.to_integer())..(List.last(range) |> String.to_integer())
      end)
      %{
        name: name,
        ranges: ranges
      }
    end)
    your_ticket = input |> Enum.at(1) |> String.split("\n", trim: true) |> List.last() |> parse_ticket()

    tickets = input |> List.last() |> String.split("nearby tickets:\n") |>
    List.last() |>
    String.split("\n", trim: true) |>
    Enum.map(&Day16.parse_ticket/1)
    %{
      rules: rules,
      your_ticket: your_ticket,
      tickets: tickets
    }
  end

  def valid_ticket?(ticket, ranges) do
    Enum.all?(ticket, fn field -> Enum.any?(ranges, fn r -> field in r end) end)
  end

  def calc_error_rate(input) do
    all_ranges = input[:rules] |> Enum.map(fn r -> r[:ranges] end) |> List.flatten()
    input[:tickets] |> Enum.reduce(0, fn ticket, acc ->
      s = Enum.filter(ticket, fn field ->
        !Enum.any?(all_ranges, fn ranges -> field in ranges end)
      end) |> Enum.sum()
      s + acc
    end)
  end

  def valid_pos_field(ranges_field, tickets, pos) do
    Enum.all?(tickets, fn ticket ->
      Enum.any?(ranges_field, fn range -> Enum.at(ticket, pos) in range end)
    end)
  end

  def find_fields_order(input) do
    all_ranges = input[:rules] |> Enum.map(fn r -> r[:ranges] end) |> List.flatten()
    valid_tickets = input[:tickets] |> Enum.filter(fn ticket -> valid_ticket?(ticket, all_ranges) end)
  end
end
