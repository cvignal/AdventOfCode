defmodule Day04 do
  @required_fields [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
  def read_input(path \\ 'input.txt') do
    File.read!(path) |>
    String.split("\n\n", trim: true) |>
    parse_input()
  end

  def parse_input(list) do
    Enum.map(list, fn passport ->
      passport |> String.split() |> Enum.reduce(%{}, fn elt, acc ->
        [field, value] = String.split(elt, ":")
        Map.merge(acc, %{:"#{field}" => value})
      end)
    end)
  end

  def validate_field(pass, :byr) do
    byr = pass[:byr]
    byr != nil && String.length(byr) == 4 && byr >= "1920" && byr <= "2002"
  end

  def validate_field(pass, :iyr) do
    iyr = pass[:iyr]
    iyr != nil && String.length(iyr) == 4 && iyr >= "2010" && iyr <= "2020"
  end

  def validate_field(pass, :eyr) do
    eyr = pass[:eyr]
    eyr != nil && String.length(eyr) == 4 && eyr >= "2020" && eyr <= "2030"
  end

  def validate_field(pass, :hgt) do
    hgt = pass[:hgt]
    case hgt do
      nil -> false
      _ ->
        {nb, unit} = Integer.parse(hgt)
        case unit do
          "cm" -> nb >= 150 && nb <= 193
          "in" -> nb >= 59 && nb <= 76
          _ -> false
        end
    end
  end

  def validate_field(pass, :hcl) do
    hcl = pass[:hcl]
    case hcl do
      nil -> false
      _ ->
        rg = Regex.compile!("#[0-9a-f]")
        String.length(hcl) == 7 && Regex.match?(rg, hcl)
    end
  end

  def validate_field(pass, :ecl) do
    ecl = pass[:ecl]
    ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  end

  def validate_field(pass, :pid) do
    pid = pass[:pid]
    case pid do
      nil -> false
      _ ->
        rg = Regex.compile!("[0-9]$")
        String.length(pid) == 9 && Regex.match?(rg, pid)
    end
  end

  def count_valid(list) do
    Enum.filter(list, fn pass ->
      Enum.all?(@required_fields, fn f ->
        res = validate_field(pass, f)
        if !res do
          IO.puts("field: #{f}, res: #{pass[:"#{f}"]}")
        end
        res
      end)
    end) |> Enum.count()
  end
end
