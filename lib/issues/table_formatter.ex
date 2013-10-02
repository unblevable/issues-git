defmodule Issues.TableFormatter do
  @moduledoc "Formats retrieved JSON structure of issues into a neat table"

  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1 ]

  def print_table_using_columns(rows, headers) do
    data_by_columns  = split_into_columns(rows, headers)
    column_widths    = widths_of(data_by_columns)
    format           = format_for(column_widths)

    puts_one_line_in_columns  headers, format
    IO.puts                   separator(column_widths)
    puts_in_columns           data_by_columns, format
  end

  @doc """
  Form a list of printable column headers.
  """
  def split_into_columns(rows, headers) do
    lc header inlist headers do
      lc row inlist rows, do: printable(row[header])
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  @doc """
  Define the width of a column based on the maximum string length of the longest
  item in the column.
  """
  def widths_of(columns) do
    lc column inlist columns do
      column |> map(&String.length/1) |> max
    end
  end

  @doc """
  Prepare formats for io::format for printing out row borders.
  """
  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  @doc """
  Adds a seperator at column edges inside row borders.
  """
  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  @doc """
  Prepares column data for output.
  """
  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&tuple_to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  @doc """
  Prints a row of data across the columns.
  """
  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end

end
