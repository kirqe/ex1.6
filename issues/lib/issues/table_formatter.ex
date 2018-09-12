defmodule Issues.TableFormatter do
  def print_table_for_issues(issues, headers) do
    with data_by_columns = split_into_columns(issues, headers),
         column_widths = widths_of(data_by_columns),
         format = format_for(column_widths)
    do
        put_one_line_in_columns(headers, format)
        IO.puts(separator(column_widths))
        put_in_columns(data_by_columns, format)
    end
  end
  
  def split_into_columns(issues, headers) do
    for header <- headers do
      for issue <- issues, do: printable(issue[header])
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(columns) do
    for column <- columns, do: column |> Enum.map(&String.length/1) |> Enum.max
  end

  def format_for(column_widths) do
    Enum.map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    Enum.map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end) <> "~n"
  end

  def put_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.each(&put_one_line_in_columns(&1, format))
  end

  def put_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end

# first try
#
# def format_row(issue) do
#   "#{issue["number"]} | #{issue["title"]} | #{issue["created_at"]}"
# end
#
# def print_table_of_issues(issues) do
#   issues
#   |> issues_and_max_title_length()
#   |> process_issues()
# end

# def print_issue_row(issue, title_length, max_length) when title_length < max_length do
#   title = String.pad_trailing(issue["title"], max_length)
#   IO.puts "#{issue["number"]} | #{title} | #{issue["created_at"]}"
# end
#
# def print_issue_row(issue, _title_length, _max_length) do
#   IO.puts "#{issue["number"]} | #{issue["title"]} | #{issue["created_at"]}"
# end

# def process_issues({issues, max_length}) do
#   issues
#   |> Enum.each(fn(issue) ->
#     sl = String.length(issue["title"])
#     print_issue_row(issue, sl, max_length)
#   end)
# end
#
# def issues_and_max_title_length(issues) do
#   max_length =
#     issues
#     |> Enum.map(fn(issue) -> issue["title"] end)
#     |> Enum.max_by(&String.length/1)
#     |> String.length
#
#   {issues, max_length}
# end
